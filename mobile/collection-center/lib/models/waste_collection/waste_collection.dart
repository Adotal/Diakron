import 'package:freezed_annotation/freezed_annotation.dart';

part 'waste_collection.freezed.dart';
part 'waste_collection.g.dart';

@freezed
abstract class WasteCollection with _$WasteCollection {

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WasteCollection({
    
    required int id,
    required String idCollector,
    required int idWasteType,
    required int idSegregator,
    required DateTime collDate,
    required bool isComplete,
    
    // Campos de la entrega (pueden ser null)
    String? idCollectionCenter,    
    DateTime? paymentDate,
    int? massGrams,
    double? bruteAmount,
    double? commission,
    double? netAmount,    

    // Extra values
    String? ccenterName,
    String? collectorName,
    String? collectorSurnames,
    String? ccenterAddress,
    
  }) = _WasteCollection;

  factory WasteCollection.fromJson(Map<String, dynamic> json) => _$WasteCollectionFromJson(json);
}