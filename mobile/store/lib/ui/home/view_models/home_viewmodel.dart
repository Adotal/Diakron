// home_viewmodel.dart
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required StoreRepository userRepository})
    : _userRepository = userRepository {
    // Command0 is used because logout doesn't require input parameters
    load = Command0(_load)..execute();
  }
  final StoreRepository _userRepository;
  late Command0 load;
  Store? store;
  final Logger _logger = Logger();
  int? manyCoupons;

  Future<Result<void>> _load() async {
    try {
      final result = await _userRepository.getStore();

      switch (result) {
        case Success<Store>():
          store = result.value;
        case Failure<Store>():
          _logger.e('Error fetching store');
          return result;
      }

      final resultManyCoupons = await _userRepository.manyCoupons();
      switch (resultManyCoupons) {
        case Success<int>():
          manyCoupons = resultManyCoupons.value;

        case Failure<int>():
          _logger.e('Error on coupons count');
      }
      return resultManyCoupons;
    } finally {
      notifyListeners();
    }
  }
}
