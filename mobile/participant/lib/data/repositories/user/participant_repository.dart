import 'package:diakron_participant/data/services/database_service.dart';
import 'package:diakron_participant/models/coupon/coupon.dart';
import 'package:diakron_participant/models/segregator/segregator.dart';
import 'package:diakron_participant/models/store/store.dart';
import 'package:diakron_participant/models/user_waste_stats/user_waste_stats.dart';
import 'package:diakron_participant/models/users/participant.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:logger/logger.dart';

class ParticipantRepository {
  ParticipantRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();
  Participant? _cachedParticipant;

  Future<Result<Participant>> getParticipant({
    bool forceRefresh = false,
  }) async {
    if (_cachedParticipant != null && !forceRefresh) {
      _logger.i('Returned cached ${_cachedParticipant.toString()}');
      return Future.value(Result.ok(_cachedParticipant!));
    }
    final result = await _databaseService.getParticipant();
    switch (result) {
      case Success<Map<String, dynamic>>():
        _cachedParticipant = Participant.fromJson(result.value);

        _logger.i('Returned refreshed ${_cachedParticipant.toString()}');
        return Result.ok(_cachedParticipant!);
      case Failure<Map<String, dynamic>>():
        return Result.error(result.error);
    }
  }

  void clearCache() {
    _cachedParticipant = null;
  }

  // THE NEXT CODE IS INTENDED FOR RETRIEVING COUPONS, STORES AND OTHER INFO, IT MUST BE MOVED TO SEPARATE REPOSITORIES

  Future<Result<List<Coupon>>> fetchCoupons() async {
    try {
      final result = await _databaseService.fetchCoupons();
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Coupon> centers = (result.value as List)
              .map((item) => Coupon.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(centers);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<Coupon>> fetchCoupon({required int couponId}) async {
    try {
      final map = await _databaseService.getRecordById(
        table: 'coupons',
        id: '$couponId',
      );

      final Coupon coupon = Coupon.fromJson(map);

      return Result.ok(coupon);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<Store>> fetchStore({required String storeId}) async {
    try {
      final map = await _databaseService.getRecordById(
        table: 'stores',
        columns:
            'id, commercial_name, address, category, post_code, schedule, path_logo',
        id: storeId,
      );

      final Store coupon = Store.fromJson(map);

      return Result.ok(coupon);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> addFavorite({
    required int couponId,
    required String participantId,
  }) async {
    try {
      final Map<String, dynamic> values = {
        'id_coupon': couponId,
        'id_participant': participantId,
      };
      final result = await _databaseService.insertTable(
        table: 'favorite_coupons',
        values: values,
      );
      return result;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<bool>> favoriteCoupon({
    required int couponId,
    required String participantId,
  }) async {
    try {
      final favoriteCoupon = await _databaseService.addfavoriteCoupon(
        couponId: couponId,
        participantId: participantId,
      );
      return favoriteCoupon;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteFavorite({
    required int couponId,
    required String participantId,
  }) async {
    try {
      final favoriteCoupon = await _databaseService.delfavoriteCoupon(
        couponId: couponId,
        participantId: participantId,
      );
      return favoriteCoupon;
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Coupon>>> fetchFavoriteCoupons({
    required String participantId,
  }) async {
    try {
      final result = await _databaseService.fetchFavoriteCoupons(
        participantId: participantId,
      );

      switch (result) {
        case Success<List<Map<dynamic, dynamic>>>():
          final List<dynamic> data = result.value;

          final List<Coupon> favoriteCoupons = data.map((item) {
            // Access the nested 'coupons' map
            final couponMap = item['coupons'] as Map<String, dynamic>;
            return Coupon.fromJson(couponMap);
          }).toList();

          return Result.ok(favoriteCoupons);

        case Failure<List<Map<dynamic, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<UserWasteStats>> getUserWS() async {
    try {
      final result = await _databaseService.fetchTableWhere(
        table: 'user_waste_stats',
        column: 'id_participant',
        value: _cachedParticipant!.id,
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          if (result.value.isEmpty) {
            // Si el usuario no tiene historial, retornamos todo en 0
            return const Result.ok(
              UserWasteStats(
                countMetal: 0,
                weightMetal: 0,
                countPlastic: 0,
                weightPlastic: 0,
                countGlass: 0,
                weightGlass: 0,
                countPaper: 0,
                weightPaper: 0,
              ),
            );
          }
          // Take only first
          return Result.ok(UserWasteStats.fromJson(result.value[0]));

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Segregator>>> fetchSegregators() async {
    try {
      final result = await _databaseService.fetchTable(
        table: 'full_segregators',
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Segregator> segregators = (result.value as List)
              .map((json) => Segregator.fromJson(json))
              .toList();

          return Result.ok(segregators);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Store>>> fetchAllStores() async {
    try {
      // Only fetch approved stores
      final result = await _databaseService.fetchTableWhere(
        table: 'full_stores', column: 'validation_status', value: 'APPROVED'
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Store> stores = (result.value as List)
              .map((item) => Store.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(stores);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteUserById({required String id}) async {
    return await _databaseService.deleteUserById(id: id);
  }
  Future<Result<void>> updateParticipant({
    required String participantId,
    required Map<String, dynamic> dataToUpdate,
  }) async {
    final result = await _databaseService.updateData(
      table: 'users',
      map: dataToUpdate,
      id: participantId,
    );

    return result;
  }
}
