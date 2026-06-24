import 'dart:io';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class RUDCouponViewmodel extends ChangeNotifier {
  RUDCouponViewmodel({
    required StoreRepository userRepository,
    required this.couponId,
  }) : _userRepository = userRepository {
    // Removed load.execute() from constructor.
    // Async calls in constructors before listeners attach can drop events.
    load = Command0(_load);
    deleteCoupon = Command0(_deleteCoupon);
    trySave =
        Command1<
          void,
          (
            String title,
            String descript,
            String pricePoints,
            String couponsLeft,
          )
        >(_trySave);
  }

  final int couponId;
  final StoreRepository _userRepository;

  Coupon? _coupon;
  Coupon? get coupon => _coupon;

  bool _isActive = true;
  bool get isActive => _isActive;

  late final Command0 load;
  late final Command0 deleteCoupon;
  late final Command1<
    void,
    (String title, String descript, String pricePoints, String couponsLeft)
  >
  trySave;

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  String? _storeId;
  String? localImagePath;
  DateTime? expirationDate;

  final Logger _logger = Logger();

  bool get isValidForSave => expirationDate != null;

  bool _isExpired = false;
  bool get isExpired => _isExpired;

  bool _isUnlimited = false;
  bool get isUnlimited => _isUnlimited;
  void toggleUnlimited(bool? value) {
    _isUnlimited = value ?? false;
    notifyListeners();
  }

  void toggleEdit() {
    _isEditing = !_isEditing;
    // Cleared out `editedCoupon` as it was tracking unmanaged parallel state.
    notifyListeners();
  }

  void toggleActive(bool value) {
    _isActive = value;
    notifyListeners();
  }

  Future<Result<void>> _load() async {
    try {
      final result = await _userRepository.fetchCoupon(couponId: couponId);

      switch (result) {
        case Success<Coupon>():

          // Store coupon
          _coupon = result.value;

          // Initialize state variables inside the Ok block
          _isActive = _coupon!.isActive;
          expirationDate = _coupon!.expirationDate;

          checkExpiration();

          // Reset any local image choices on reload
          localImagePath = null;

          // Sets if stock is unlimited
          _isUnlimited = _coupon!.couponsLeft == null;

          _logger.w(_coupon.toString());
        case Failure<Coupon>():
          _logger.e(result.error);
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void checkExpiration() {
    // If its expired, set flag
    _isExpired = DateTime.now().isAfter(expirationDate!);
  }

  Future<Result<void>> _trySave(
    (String, String, String, String) couponData,
  ) async {
    final resultStore = await _userRepository.getStore();
    switch (resultStore) {
      case Success<Store>():
        _storeId = resultStore.value.id;
      case Failure<Store>():
        return Result.error(resultStore.error);
    }

    final (title, descript, pricePoints, couponsLeft) = couponData;
    final int pricePointsInt = int.parse(pricePoints);
    // Stock es null cuando es ilimitado
    final int? couponsLeftInt = _isUnlimited ? null : int.parse(couponsLeft);

    String remoteImagePath = _coupon!.pathImage;
    String? oldImageToDelete;

    // 1. Upload NEW Image First
    if (localImagePath != null) {
      final file = File(localImagePath!);
      if (!await file.exists()) {
        return Result.error(Exception('No image found'));
      }

      final uniqueFileName =
          'coupon_${DateTime.now().millisecondsSinceEpoch}.png';

      try {
        await _userRepository.uploadFile(
          id: _storeId!,
          fileName: uniqueFileName,
          file: file,
          isPrivate: false,
        );
        remoteImagePath = '$_storeId/$uniqueFileName';

        // 2. Mark old image for deletion ONLY if upload succeeds
        oldImageToDelete = _coupon!.pathImage;
      } catch (e) {
        return Result.error(Exception('Image upload failed: $e'));
      }
    }

    // 3. Update Database
    final updatedCoupon = Coupon(
      id: couponId,
      idStore: _storeId!,
      title: title,
      descript: descript,
      pricePoints: pricePointsInt,
      expirationDate: expirationDate!,
      couponsLeft: couponsLeftInt,
      isActive: _isActive,
      pathImage: remoteImagePath,
    );

    final result = await _userRepository.updateCupon(updatedCoupon);

    // 4. Cleanup old image ONLY if database update succeeds
    switch (result) {
      case Success<void>():
        if (oldImageToDelete != null) {
          // Fire and forget, or handle errors silently.
          // At this point, the UI has succeeded.
          _userRepository.deleteCouponImage(path: oldImageToDelete);
        }
        return Result.ok(null);
      case Failure<void>():
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _deleteCoupon() async {
    final result = await _userRepository.deleteCoupon(couponId: couponId);

    // Only delete the image if the database deletion succeeds
    if (result is Success) {
      await _userRepository.deleteCouponImage(path: _coupon!.pathImage);
    }

    return result;
  }

  void updatePathLogo(String path) {
    localImagePath = path;
    notifyListeners();
  }

  void updateTime(DateTime t) {
    expirationDate = t;
    checkExpiration();
    notifyListeners();
  }
}
