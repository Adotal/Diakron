import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/models/coupon/coupon.dart';
import 'package:diakron_participant/models/store/store.dart';
import 'package:diakron_participant/models/users/participant.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class CouponDetailViewmodel extends ChangeNotifier {
  CouponDetailViewmodel({
    required ParticipantRepository participantRepository,
    required int couponId,
  }) : _participantRepository = participantRepository,
       _couponId = couponId {
    load = Command0(_load)..execute();
    toggleFavorite = Command0(_toggleFavorite);
    redeemBenefit = Command0(_redeemBenefit);
  }

  final int _couponId;
  int get couponId => _couponId;
  int _userPoints = 0;
  int get userPoints => _userPoints;
  // For adding favorites
  String? _userId;
  String get userId => _userId!;
  final ParticipantRepository _participantRepository;

  late Command0 load;
  late Command0 toggleFavorite;
  late Command0 redeemBenefit;

  Coupon? _coupon;
  Coupon? get coupon => _coupon;
  Store? _store;
  Store? get store => _store;
  final _logger = Logger();

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<Result<void>> _load() async {
    try {
      // Get participant Id and points
      final user = await _participantRepository.getParticipant();
      switch (user) {
        case Success<Participant>():
          _userId = user.value.id;
          _userPoints = user.value.points;
        case Failure<Participant>():
          return Result.error(user.error);
      }

      // First load coupon
      final result = await _participantRepository.fetchCoupon(
        couponId: _couponId,
      );

      switch (result) {
        case Success<Coupon>():
          // Store coupon info
          _coupon = result.value;
          _logger.w(_coupon.toString());
        case Failure<Coupon>():
          _logger.e(result.error);
      }

      // Check if its a favorite
      final favoriteCoupon = await _participantRepository.favoriteCoupon(
        couponId: _couponId,
        participantId: _userId!,
      );

      switch (favoriteCoupon) {
        case Success<bool>():
          _isFavorite = favoriteCoupon.value;
        case Failure<bool>():
          return Result.error(favoriteCoupon.error);
      }

      // Finally load store
      final resultStore = await _participantRepository.fetchStore(
        storeId: _coupon!.idStore,
      );

      switch (resultStore) {
        case Success<Store>():
          _store = resultStore.value; // Reset any local image choices on reload
          _logger.w(_store.toString());
        case Failure<Store>():
          _logger.e(resultStore.error);
      }

      return resultStore;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        final result = await _participantRepository.deleteFavorite(
          couponId: _couponId,
          participantId: _userId!,
        );

        switch (result) {
          case Success<void>():
            _isFavorite = false;
          case Failure<void>():
            _logger.e('Error adding fav ${result.error}');
        }
        return result;
      } else {
        final result = await _participantRepository.addFavorite(
          couponId: _couponId,
          participantId: _userId!,
        );

        switch (result) {
          case Success<void>():
            _isFavorite = true;
          case Failure<void>():
            _logger.e('Error adding fav ${result.error}');
        }
        return result;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _redeemBenefit() async {
    if (_coupon!.pricePoints > userPoints) {
      return Result.error(Exception('No enough points'));
    }
    return Result.ok(null);
  }
}
