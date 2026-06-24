import 'dart:io';
import 'package:diakron_stores/data/services/database_service.dart';
import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/models/incentive/incentive.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class StoreRepository extends ChangeNotifier {
  StoreRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();
  Store? _cachedStore;

  Future<Result<Store>> getStore({bool forceRefresh = false}) async {
    if (_cachedStore != null && !forceRefresh) {
      _logger.i(
        'Returned cached ${_cachedStore!.validationStatus} ${_cachedStore.toString()}',
      );
      return Future.value(Result.ok(_cachedStore!));
    }
    final result = await _databaseService.getStore();
    switch (result) {
      case Success<Map<String, dynamic>>():
        _cachedStore = Store.fromJson(result.value);

        _logger.i(
          'Returned refreshed ${_cachedStore!.validationStatus} ${_cachedStore.toString()}',
        );
        notifyListeners();

        return Result.ok(_cachedStore!);
      case Failure<Map<String, dynamic>>():
        return Result.error(result.error);
    }
  }

  Future<void> clearCache() async {
    _cachedStore = null;
    notifyListeners();
  }

  Future<Result<List<Coupon>>> fetchCoupons() async {
    try {
      // final result = await _databaseService.fetchCoupons(
      //   storeId: _cachedStore!.id!,
      // );
      final result = await _databaseService.fetchTableWhere(table: 'full_coupons', column: 'id_store', value: _cachedStore!.id!);
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

  Future<String?> uploadFile({
    required String id,
    required String fileName,
    required File file,
    required bool isPrivate,
  }) async {
    if (isPrivate) {
      return await _databaseService.uploadPrivateFile(
        id: id,
        fileName: fileName,
        file: file,
      );
    }
    return await _databaseService.uploadPublicFile(
      id: id,
      fileName: fileName,
      file: file,
    );
  }

  Future<Result<void>> uploadUserData(
    String table,
    String id,
    Store store,
  ) async {
    final fullMap = store.toJson();
    final String id = store.id!;

    const userTableKeys = {
      'id',
      'user_name',
      'surnames',
      'phone_number',
      'is_active',
      'user_type',
      'created_at',
    };

    // Map without userbase data
    final specificData = Map<String, dynamic>.from(fullMap)
      ..removeWhere((key, _) => userTableKeys.contains(key));

    final result = await _databaseService.uploadUserData(
      table: table,
      id: id,
      data: specificData,
    );
    return result;
  }

  Future<Result<void>> uploadCupon(Coupon coupon) async {
    // For supabase to gen the id, it should not be sended
    final map = coupon.toJson();
    map.remove('id');
    return await _databaseService.insertTable(table: 'coupons', values: map);
  }

  Future<Result<void>> updateCupon(Coupon coupon) async {
    return await _databaseService.updateRecordById(
      table: 'coupons',
      values: coupon.toJson(),
      id: coupon.id.toString(),
    );
  }

  Future<Result<Coupon>> fetchCoupon({required int couponId}) async {
    try {
      final map = await _databaseService.getRecordById(
        table: 'full_coupons',
        id: '$couponId',
      );
      final Coupon coupon = Coupon.fromJson(map);

      return Result.ok(coupon);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteCouponImage({required String path}) async {
    try {
      return await _databaseService.deleteFromPublicStorage(path: path);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteCoupon({required int couponId}) async {
    try {
      return await _databaseService.deleteRecordById(
        table: 'coupons',
        id: '$couponId',
      );
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<int>> manyCoupons() async {
    try {
      return await _databaseService.manyCoupons(storeId: _cachedStore!.id!);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<Incentive>>> fetchIncentives() async {
    try {
      final result = await _databaseService.fetchTableWhere(
        table: 'incentives_stores',
        column: 'id_store',
        value: _cachedStore!.id!,
      );
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Incentive> incentives = (result.value as List)
              .map((item) => Incentive.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(incentives);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

 Future<Result<void>> deleteUserById({required String id}) async {
    return await _databaseService.deleteUserById(id: id);
  }

    Future<Result<void>> updateStore({
    required String storeId,
    required Map<String, dynamic> dataToUpdate,
  }) async {
    final result = await _databaseService.updateData(
      table: 'users',
      map: dataToUpdate,
      id: storeId,
    );

    return result;
  }

}
