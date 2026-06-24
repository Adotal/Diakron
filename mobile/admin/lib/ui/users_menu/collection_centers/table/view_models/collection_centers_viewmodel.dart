import 'package:diakron_admin/data/repositories/global/waste_repository.dart';
import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/models/users/collection_center/collection_center.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CollectionCentersViewmodel extends ChangeNotifier {
  CollectionCentersViewmodel({
    required CollectionCenterRepository ccenterRepository,
    required WasteRepository wasteRepository,
  }) : _ccenterRepository = ccenterRepository,
       _wasteRepository = wasteRepository {
    load = Command0(_load);
    // updateCCenter  = Command1(_deleteBooking);
    // deleteCCenter = Command1(_deleteBooking);
  }

  final CollectionCenterRepository _ccenterRepository;
  final WasteRepository _wasteRepository;

  List<CollectionCenter> _allcollectionCenters = [];
  List<CollectionCenter> _filteredCollectionCenters = [];
  List<CollectionCenter> get collectionCenters => _filteredCollectionCenters;

  late Command0 load;
  final Logger _logger = Logger();
  String _searchQuery = '';

  Future<Result> _load() async {
    try {
      // Fetch all CollectionCenters
      final result = await _ccenterRepository.fetchCCenters();
      ();

      switch (result) {
        case Success<List<CollectionCenter>>():
          _allcollectionCenters = result.value;
          _applyFilters();
        case Failure<List<CollectionCenter>>():
          _logger.w('Failed to load CCenters ${result.error}');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allcollectionCenters.where((c) {
      // Filtro de Búsqueda
      if (_searchQuery.isNotEmpty) {
        if (c.commercialName == null) {
          return false;
        }
        if (!c.commercialName!.toLowerCase().contains(
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

    _filteredCollectionCenters = temp;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
}
