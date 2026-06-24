import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';
part 'coupon.g.dart';

@freezed
abstract class Coupon with _$Coupon {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Coupon({
    required int? id,
    required String idStore,
    required String title,
    required String descript,
    required int pricePoints,
    required DateTime expirationDate,
    required int? couponsLeft,
    required bool isActive,
    required String pathImage,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, Object?> json) => _$CouponFromJson(json);


  // Private constructor to enable getters and methods in Freezed model
  const Coupon._();
  
  String get urlImage => '${dotenv.get('SUPABASE_URL')}/storage/v1/object/public/diakron_storage_public/$pathImage';
}
