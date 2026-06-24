import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/incentive/incentive.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ActivityViewModel extends ChangeNotifier {
  ActivityViewModel({required StoreRepository userRepository})
    : _userRepository = userRepository {
    load = Command0(_load);
  }

  final Logger _logger = Logger();
  late final Command0 load;
  final StoreRepository _userRepository;

  List<Incentive> _allIncentives = [];
  List<Incentive> _filteredIncentives = [];

  // The UI should ONLY read from _filteredIncentives
  List<Incentive> get incentives => _filteredIncentives;

  DateTimeRange? dateRange;

  Future<Result> _load() async {
    try {
      // Load cached store if not exits
      await _userRepository.getStore();

      final result = await _userRepository.fetchIncentives();

      switch (result) {
        case Success<List<Incentive>>():
          _allIncentives = result.value;
          _applyFilterByDate();
          _logger.i(_allIncentives);
        case Failure<List<Incentive>>():
          _logger.w('Failed to load Coupons ${result.error}');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }

  void updateDateRange(DateTimeRange? values) {
    dateRange = values;
    _applyFilterByDate();
  }

  void _applyFilterByDate() {
    // Apply Text Search (by title)
    var temp = _allIncentives.where((c) {
      if (dateRange != null) {
        // Usamos isBefore e isAfter ajustando un día para que sea inclusivo
        final start = dateRange!.start.subtract(const Duration(days: 1));
        final end = dateRange!.end.add(const Duration(days: 1));

        if (c.createdAt.toLocal().isBefore(start) ||
            c.createdAt.toLocal().isAfter(end)) {
          return false;
        }
      }
      return true;
    }).toList();

    // // Apply Sort
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
    // break;
    // }

    _filteredIncentives = temp;
    notifyListeners();
  }
}
