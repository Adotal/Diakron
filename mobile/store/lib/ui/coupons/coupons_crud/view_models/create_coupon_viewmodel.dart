import 'dart:io';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
class CreateCouponViewmodel extends ChangeNotifier {
  CreateCouponViewmodel({required StoreRepository userRepository})
      : _userRepository = userRepository {
    trySave = Command1<
        void,
        (String title, String descript, String pricePoints, String couponsLeft)
    >(_trySave);
  }

  final StoreRepository _userRepository;

  String? _storeId;

  // Renamed to clarify this is the local device path
  String? localImagePath; 
  DateTime? expirationDate = DateTime.now();

  bool _isUnlimited = false;
  bool get isUnlimited => _isUnlimited;
  void toggleUnlimited(bool? value){
    _isUnlimited = value ?? false;
    notifyListeners();
  }

  late final Command1<
      void,
      (String title, String descript, String pricePoints, String couponsLeft)>
      trySave;

  final Logger _logger = Logger();

  // Expose validation check to the view without holding a FormKey
  bool get isValidForSave => localImagePath != null && expirationDate != null;

  Future<Result<void>> _trySave(
    (String, String, String, String) couponData,
  ) async {
    final resultStore = await _userRepository.getStore();
    switch (resultStore) {
      case Success<Store>():
        _storeId = resultStore.value.id;
      case Failure<Store>():
        _logger.e('Error getting storeID');
        return Result.error(resultStore.error);
    }

    final (title, descript, pricePoints, couponsLeft) = couponData;
    final int pricePointsInt = int.parse(pricePoints);
    // Stock es null cuando es ilimitado
    final int? couponsLeftInt = _isUnlimited ? null : int.parse(couponsLeft);

    final file = File(localImagePath!);
    if (!await file.exists()) return Result.error(Exception('No image found'));

    // 1. Generate a unique file name to prevent overwriting existing coupons
    final uniqueFileName = 'coupon_${DateTime.now().millisecondsSinceEpoch}.png';

    // 2. AWAIT the upload. Previously, the coupon was saving before the image finished.
    try {
      await _userRepository.uploadFile(
        id: _storeId!,
        fileName: uniqueFileName,
        file: file,
        isPrivate: false,
      );
    } catch (e) {
      _logger.e("Image upload failed: $e");
      return Result.error(Exception('Image upload failed'));
    }

    // 3. Keep local path intact, build remote path for DB
    final remoteImagePath = '$_storeId/$uniqueFileName';

    final coupon = Coupon(
      id: null,
      idStore: _storeId!,
      title: title,
      descript: descript,
      pricePoints: pricePointsInt,
      expirationDate: expirationDate!,
      couponsLeft: couponsLeftInt,
      isActive: true,
      pathImage: remoteImagePath,
    );

    final result = await _userRepository.uploadCupon(coupon);
    switch (result) {
      case Success<void>():
        return Result.ok(null);
      case Failure<void>():
        _logger.e("ERROR UPLOADING COUPON ${result.error}");
        return Result.error(result.error);
    }
  }

  void updatePathLogo(String path) {
    localImagePath = path;
    notifyListeners();
  }

  void updateTime(DateTime t) {
    expirationDate = t;
    notifyListeners();
  }
}