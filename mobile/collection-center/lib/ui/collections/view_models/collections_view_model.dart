import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/waste_collection/waste_collection.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum CollectionSort { none, dateAsc, dateDesc }

enum CollectionFilterType {
  none,
  date,
  metal,
  plastic,
  paper,
  glass,
}

class CollectionsViewModel extends ChangeNotifier {
  CollectionsViewModel({required CCenterRepository ccenterRepository})
    : _ccenterRepository = ccenterRepository {
    load = Command0(_load);
  }

  final Logger _logger = Logger();
  late final Command0 load;
  final CCenterRepository _ccenterRepository;

  List<WasteCollection> _allWasteCollections = [];
  List<WasteCollection> _filteredCollections = [];
  List<Map<String, dynamic>> allWasteTypes = [
    // {'id': 1, 'waste_type': 'PLÁSTICO'},
    // {'id': 2, 'waste_type': 'METAL'},
    // {'id': 3, 'waste_type': 'VIDRIO'},
    // {'id': 4, 'waste_type': 'PAPEL/CARTÓN'},
  ];

  // Estado de Filtros ---
  CollectionFilterType _currentFilter = CollectionFilterType.none;
  CollectionFilterType get currentFilter => _currentFilter;

  CollectionSort _currentSort = CollectionSort.none;
  CollectionSort get currentSort => _currentSort;
  // The UI should ONLY read from _filteredCollections
  List<WasteCollection> get collections => _filteredCollections;

  DateTimeRange? dateRange;

  Future<Result> _load() async {
    try {
      // Load cached store if not exits
      await _ccenterRepository.getCollectionCenter();

      // Fetch waste types

      final resultWT = await _ccenterRepository.fetchWasteTypes();
      switch (resultWT) {
        case Success<List<Map<String, dynamic>>>():
          allWasteTypes = resultWT.value;
        case Failure<List<Map<String, dynamic>>>():
          _logger.w('Failed to fecth Waste Types ${resultWT.error}');
          return Result.error(resultWT.error);
      }

      // Fetch collections
      final result = await _ccenterRepository.fetchWasteCollections();
      switch (result) {
        case Success<List<WasteCollection>>():
          _allWasteCollections = result.value;
          _applyFilters();
          _logger.i(_allWasteCollections);
        case Failure<List<WasteCollection>>():
          _logger.w('Failed to load Coupons ${result.error}');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }

  void updateDateRange(DateTimeRange? values) {
    dateRange = values;
    _applyFilters();
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allWasteCollections.where((c) {
      // Filtros de Rango/Fechas
      switch (_currentFilter) {
        case CollectionFilterType.date:
          if (dateRange != null) {
            // Usamos isBefore e isAfter ajustando un día para que sea inclusivo
            final start = dateRange!.start.subtract(const Duration(days: 1));
            final end = dateRange!.end.add(const Duration(days: 1));
            if (c.collDate.isBefore(start) || c.collDate.isAfter(end)) {
              return false;
            }
          }
          break;
        case CollectionFilterType.none:
          break;
        case CollectionFilterType.metal:
        case CollectionFilterType.plastic:
        case CollectionFilterType.paper:
        case CollectionFilterType.glass:
          if (c.idWasteType != _mapFilterToId(_currentFilter)) return false;
          break;
      }
      return true;
    }).toList();

    // Always sort date asc
    _currentSort = CollectionSort.dateDesc;

    // Apply Sort
    switch (_currentSort) {
      case CollectionSort.dateAsc:
        temp.sort((a, b) => a.collDate.compareTo(b.collDate));
        break;
      case CollectionSort.dateDesc:
        temp.sort((a, b) => b.collDate.compareTo(a.collDate));
        break;
      case CollectionSort.none:
      default:
        // Optional: Default sort (e.g., newest first based on ID or creation date)
        break;
    }

    _filteredCollections = temp;
    notifyListeners();
  }

  void updateSort(CollectionSort sort) {
    _currentSort = sort;
    _applyFilters();
  }

  void updateFilterType(CollectionFilterType filter) {
    if (filter == _currentFilter) {
      // Toggle, if selects again deactivate
      _currentFilter = CollectionFilterType.none;
    } else {
      _currentFilter = filter;
    }
    _applyFilters();
  }

  // Helper para vincular el Enum con los IDs de tu base de datos
  int _mapFilterToId(CollectionFilterType filter) {
    switch (filter) {
      case CollectionFilterType.plastic:
        return 1;
      case CollectionFilterType.metal:
        return 2;
      case CollectionFilterType.glass:
        return 3;
      case CollectionFilterType.paper:
        return 4;
      default:
        return 0;
    }
  }
}
