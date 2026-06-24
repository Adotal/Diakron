import 'package:diakron_admin/data/repositories/users/collector_repository.dart';
import 'package:diakron_admin/models/users/collector/collector.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CollectorsViewModel extends ChangeNotifier {
  CollectorsViewModel({required CollectorRepository collectorRepository})
    : _collectorRepository = collectorRepository {
    load = Command0(_load);
    // updateCCenter  = Command1(_deleteBooking);
    // deleteCCenter = Command1(_deleteBooking);
  }

  final CollectorRepository _collectorRepository;

  List<Collector> _allCollectors = [];
  List<Collector> _filteredCollectors = [];
  List<Collector> get collectors => _filteredCollectors;

  late Command0 load;
  final Logger _logger = Logger();
  String _searchQuery = '';

  Future<Result> _load() async {
    try {
      // Fetch all CollectionCenters
      final result = await _collectorRepository.fetchCollectors();
      ();

      switch (result) {
        case Success<List<Collector>>():
          _allCollectors = result.value;
          _applyFilters();
        case Failure<List<Collector>>():
          _logger.w('Failed to load Collectors ${result.error}');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allCollectors.where((c) {
      // Filtro de Búsqueda
      if (_searchQuery.isNotEmpty) {
        if (!c.userName!.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        )) {
          return false;
        }
      }
      return true;
    }).toList();

    // Apply Sort
    // switch (_currentSort) {
    //   case CouponSort.priceAsc:
    //     temp.sort((a, b) => a.pricePoints.compareTo(b.pricePoints));
    //     break;
    //   case CouponSort.priceDesc:
    //     temp.sort((a, b) => b.pricePoints.compareTo(a.pricePoints));
    //     break;
    //   case CouponSort.dateAsc:
    //     temp.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    //     break;
    //   case CouponSort.dateDesc:
    //     temp.sort((a, b) => b.expirationDate.compareTo(a.expirationDate));
    //     break;
    //   case CouponSort.redeemAsc:
    //     temp.sort((a, b) => b.redeemTimes.compareTo(a.redeemTimes));
    //     break;
    //   case CouponSort.redeemDesc:
    //     temp.sort((a, b) => a.redeemTimes.compareTo(b.redeemTimes));
    //     break;
    //   case CouponSort.none:
    //   default:
    //     // Optional: Default sort (e.g., newest first based on ID or creation date)
    //     break;
    // }

    _filteredCollectors = temp;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
}
