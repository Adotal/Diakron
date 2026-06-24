import 'package:diakron_admin/data/repositories/users/admin_repository.dart';
import 'package:diakron_admin/models/incentive/incentive.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum IncentiveSort { none, dateAsc, dateDesc }

enum IncentiveFilterType { none, date }

class IncentivesViewModel extends ChangeNotifier {
  IncentivesViewModel({required AdminRepository adminRepository})
    : _adminRepository = adminRepository {
    load = Command0(_load);
  }

  final Logger _logger = Logger();
  late final Command0 load;
  final AdminRepository _adminRepository;

  List<Incentive> _allIncentives = [];
  List<Incentive> _filteredIncentives = [];
  List<Incentive> get incentives => _filteredIncentives;

  // Estado de Filtros ---
  IncentiveFilterType _currentFilter = IncentiveFilterType.none;
  IncentiveFilterType get currentFilter => _currentFilter;

  IncentiveSort _currentSort = IncentiveSort.none;
  IncentiveSort get currentSort => _currentSort;
  // The UI should ONLY read from _filteredIncentives

  DateTimeRange? dateRange;
  String _searchQuery = '';
  bool get isSearching => _searchQuery.isNotEmpty;

  Future<Result> _load() async {
    try {
      // Fetch collections
      final result = await _adminRepository.fetchIncentives();
      switch (result) {
        case Success<List<Incentive>>():
          _allIncentives = result.value;
          _applyFilters();
          _logger.i(_allIncentives);
        case Failure<List<Incentive>>():
          _logger.w('Failed to load Incentives ${result.error}');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }


  void updateDateRange(DateTimeRange? values) {
    dateRange = values;
    _applyFilters();
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allIncentives.where((c) {
      // 1. Search filter
      if (_searchQuery.isNotEmpty &&
          !c.storeCommercialName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          )) {
        return false;
      }

      // 2. Date filter
      if (_currentFilter == IncentiveFilterType.date && dateRange != null) {
        // Usamos isBefore e isAfter ajustando un día para que sea inclusivo
        final start = dateRange!.start.subtract(const Duration(days: 1));
        final end = dateRange!.end.add(const Duration(days: 1));

        if (c.createdAt.isBefore(start) || c.createdAt.isAfter(end)) {
          return false;
        }
      }

      return true;
    }).toList();

    _filteredIncentives = temp;
    notifyListeners();
  }

  void updateSort(IncentiveSort sort) {
    _currentSort = sort;
    _applyFilters();
  }

  void updateFilterType(IncentiveFilterType filter) {
    if (filter == _currentFilter) {
      // Toggle, if selects again deactivate
      _currentFilter = IncentiveFilterType.none;
    } else {
      _currentFilter = filter;
    }
    _applyFilters();
  }

  // Function to clean everything
  void clearFilters() {
    _searchQuery = "";
    _applyFilters();
  }
}
