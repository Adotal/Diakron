import 'package:diakron_collectors/data/services/database_service.dart';
import 'package:diakron_collectors/models/segregator/segregator.dart';
import 'package:diakron_collectors/models/users/collector.dart';
import 'package:diakron_collectors/models/waste_collection/waste_collection.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:logger/logger.dart';

class CollectorRepository {
  CollectorRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();
  Collector? _cachedCollector;
  Collector get cachedCollector => _cachedCollector!;

  Future<Result<Collector>> getCollector({bool forceRefresh = false}) async {
    if (_cachedCollector != null && !forceRefresh) {
      _logger.i('Returned cached ${_cachedCollector.toString()}');
      return Future.value(Result.ok(_cachedCollector!));
    }
    final result = await _databaseService.getCollector();
    switch (result) {
      case Success<Map<String, dynamic>>():
        _cachedCollector = Collector.fromJson(result.value);

        _logger.i('Returned refreshed ${_cachedCollector.toString()}');
        return Result.ok(_cachedCollector!);
      case Failure<Map<String, dynamic>>():
        return Result.error(result.error);
    }
  }

  void clear() {
    _cachedCollector = null;
  }

  // THE NEXT CODE IS INTENDED FOR RETRIEVING COUPONS, STORES AND OTHER INFO, IT MUST BE MOVED TO SEPARATE REPOSITORIES

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

  Future<Result<List<Map<String, dynamic>>>> fetchWasteTypes() async {
    try {
      final result = await _databaseService.fetchTable(table: 'waste_types');

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          return Result.ok(result.value);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<WasteCollection>>> fetchWasteCollections() async {
    try {
      final result = await _databaseService.fetchTableWhere(
        table: 'full_waste_collections',
        column: 'id_collector',
        value: _cachedCollector!.id,
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<WasteCollection> wasteCollections = (result.value as List)
              .map((json) => WasteCollection.fromJson(json))
              .toList();

          return Result.ok(wasteCollections);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<String>> fetchCollectionQR({required String idCollection}) async {
    try {
      final result = await _databaseService.fetchTableWhere(
        table: 'waste_collections_payloads',
        column: 'id_collection',
        value: idCollection,
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
        // Retorna solamente payload del primer y único resultado
          return Result.ok(result.value[0]['payload']);
        case Failure<List<Map<String, dynamic>>>():          
          return Result.error(result.error);
      }

    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
