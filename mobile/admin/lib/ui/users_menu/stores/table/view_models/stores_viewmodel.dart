import 'dart:ffi';

import 'package:diakron_admin/data/repositories/users/store_repository.dart';
import 'package:diakron_admin/models/users/store/store.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class StoresViewModel extends ChangeNotifier {
  StoresViewModel({required StoreRepository storeRepository})
    : _storeRepository = storeRepository {
    load = Command0(_load);
    // updateCCenter  = Command1(_deleteBooking);
    // deleteCCenter = Command1(_deleteBooking);
  }

  final StoreRepository _storeRepository;

  List<Store> _allStores = [];
  List<Store> _filteredStores = [];
  List<Store> get stores => _filteredStores;

  late final Command0 load;
  final Logger _logger = Logger();
  String _searchQuery = '';
  int? _totalPoints;
  int get totalPoints => _totalPoints!;

  Future<Result> _load() async {
    try {
      // Fetch all CollectionCenters
      final result = await _storeRepository.fetchStores();
      ();

      switch (result) {
        case Success<List<Store>>():
          _allStores = result.value;
          _applyFilters();
        case Failure<List<Store>>():
          _logger.w('Failed to load Stores ${result.error}');
          return result;
      }

      final resultPoints = await _storeRepository.getTotalPoints();
      switch (resultPoints) {
        case Success<int>():
          _totalPoints = resultPoints.value;
          _logger.i(_totalPoints);
          return const Result.ok(null);
        case Failure<int>():
          _logger.e(resultPoints.error);
          return Result.error(resultPoints.error);
      }
    } finally {
      notifyListeners();
    }
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allStores.where((c) {
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

    _filteredStores = temp;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
}
