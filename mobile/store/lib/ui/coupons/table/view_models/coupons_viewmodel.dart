import 'dart:math';

import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

enum CouponSort {
  none,
  priceAsc,
  priceDesc,
  dateAsc,
  dateDesc,
  redeemAsc,
  redeemDesc,
}

enum CouponFilterType { none, price, redeemTimes, expirationDate }

class CouponsViewmodel extends ChangeNotifier {
  CouponsViewmodel({required StoreRepository userRepository})
    : _userRepository = userRepository {
    load = Command0(_load);
  }

  final StoreRepository _userRepository;
  String? storeId;

  // Two list, one for source of truth and second for search and filters
  List<Coupon> _allCoupons = [];
  List<Coupon> _filteredCoupons = [];

  // The UI should ONLY read from _filteredCoupons
  List<Coupon> get coupons => _filteredCoupons;

  // Checks if there are absolutely zero coupons in the system
  bool get isDatabaseEmpty => _allCoupons.isEmpty;

  String _searchQuery = '';
  CouponSort _currentSort = CouponSort.none;
  CouponSort get currentSort => _currentSort;

  late final Command0 load;
  final Logger _logger = Logger();

  // Estado de Filtros ---
  CouponFilterType _currentFilter = CouponFilterType.none;
  CouponFilterType get currentFilter => _currentFilter;

  RangeValues? priceRange;
  RangeValues? redeemRange;
  DateTimeRange? dateRange;
  double maxPrice = 100;
  double maxRedeems = 10;

  Future<Result> _load() async {
    try {
      // Cache storeId to prevent redundant network requests on refresh
      if (storeId == null) {
        final storeResult = await _userRepository.getStore();
        switch (storeResult) {
          case Success<Store>():
            storeId = storeResult.value.id;
          case Failure<Store>():
            _logger.e('Error fetching store');
            return storeResult; // Fast fail: abort if critical context is missing
        }
      }

      // Fetch Coupons
      final result = await _userRepository.fetchCoupons();

      switch (result) {
        case Success<List<Coupon>>():
          _allCoupons = result.value;
          _calculateMaxFilterRanges(); // Calcular máximos antes de filtrar
          _applyFilters();

          _logger.d('Loaded ${_allCoupons.length} Coupons');

        case Failure<List<Coupon>>():
          _logger.w('Failed to load Coupons ${result.error}');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  // Detecta el valor máximo de la DB para que los RangeSlider tengan un límite dinámico
  void _calculateMaxFilterRanges() {
    if (_allCoupons.isEmpty) return;

    maxPrice = _allCoupons.map((c) => c.pricePoints.toDouble()).reduce(max);
    maxRedeems = _allCoupons.map((c) => c.redeemTimes.toDouble()).reduce(max);

    // Evitar max = 0 para que el RangeSlider no falle
    if (maxPrice == 0) maxPrice = 1;
    if (maxRedeems == 0) maxRedeems = 1;

    priceRange ??= RangeValues(0, maxPrice);
    redeemRange ??= RangeValues(0, maxRedeems);
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateSort(CouponSort sort) {
    _currentSort = sort;
    _applyFilters();
  }

  void updateFilterType(CouponFilterType filter) {
    _currentFilter = filter;
    _applyFilters();
  }

  void updatePriceRange(RangeValues values) {
    priceRange = values;
    _applyFilters();
  }

  void updateRedeemRange(RangeValues values) {
    redeemRange = values;
    _applyFilters();
  }

  void updateDateRange(DateTimeRange values) {
    dateRange = values;
    _applyFilters();
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allCoupons.where((c) {

      // Filtro de Búsqueda
      if (_searchQuery.isNotEmpty && !c.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      // Filtros de Rango/Fechas
      switch (_currentFilter) {
        case CouponFilterType.price:
          if (priceRange != null) {
            if (c.pricePoints < priceRange!.start || c.pricePoints > priceRange!.end) return false;
          }
          break;
        case CouponFilterType.redeemTimes:
          if (redeemRange != null) {
            if (c.redeemTimes < redeemRange!.start || c.redeemTimes > redeemRange!.end) return false;
          }
          break;
        case CouponFilterType.expirationDate:
          if (dateRange != null) {
            // Usamos isBefore e isAfter ajustando un día para que sea inclusivo
            final start = dateRange!.start.subtract(const Duration(days: 1));
            final end = dateRange!.end.add(const Duration(days: 1));
            if (c.expirationDate.isBefore(start) || c.expirationDate.isAfter(end)) return false;
          }
          break;
        case CouponFilterType.none:
          break;
      }
      return true;
    }).toList();

    // Apply Sort
    switch (_currentSort) {
      case CouponSort.priceAsc:
        temp.sort((a, b) => a.pricePoints.compareTo(b.pricePoints));
        break;
      case CouponSort.priceDesc:
        temp.sort((a, b) => b.pricePoints.compareTo(a.pricePoints));
        break;
      case CouponSort.dateAsc:
        temp.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
        break;
      case CouponSort.dateDesc:
        temp.sort((a, b) => b.expirationDate.compareTo(a.expirationDate));
        break;
      case CouponSort.redeemAsc:
        temp.sort((a, b) => b.redeemTimes.compareTo(a.redeemTimes));
        break;
      case CouponSort.redeemDesc:
        temp.sort((a, b) => a.redeemTimes.compareTo(b.redeemTimes));
        break;
      case CouponSort.none:
      default:
        // Optional: Default sort (e.g., newest first based on ID or creation date)
        break;
    }

    _filteredCoupons = temp;
    notifyListeners();
  }
}
