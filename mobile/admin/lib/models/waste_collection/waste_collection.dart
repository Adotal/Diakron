import 'package:freezed_annotation/freezed_annotation.dart';

part 'waste_collection.freezed.dart';
part 'waste_collection.g.dart';

@freezed
abstract class WasteCollection with _$WasteCollection {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WasteCollection({
    required int id,
    required int idWasteType,
    required int idSegregator,
    required DateTime collDate,
    required bool isComplete,

    // Campos de la entrega (pueden ser null)
    String? idCollectionCenter,
    String? ccenterName,
    DateTime? paymentDate,
    int? massGrams,
    double? bruteAmount,
    double? commission,
    double? netAmount,
  }) = _WasteCollection;

  factory WasteCollection.fromJson(Map<String, dynamic> json) =>
      _$WasteCollectionFromJson(json);


  // Added constructor for personalized methods
  const WasteCollection._();

  bool isExpired() {
    return isMoreThan24Hours(collDate);
  }

  bool isMoreThan24Hours(DateTime pastDate) {
    final now = DateTime.now();
    final difference = now.difference(pastDate);
    // Returns true if 24 hours or more have passed
    return difference.inHours >= 24;
  }
}
