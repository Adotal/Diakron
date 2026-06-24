import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/models/users/collection_center/collection_center.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';

class CollectionCenterRepository {
  CollectionCenterRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;

  final _logger = Logger();

  Future<Result<List<Map<String, dynamic>>>> fetchAllWasteTypes() async {
    try {
      final result = await _databaseService.fetchAllWasteTypes();

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          return Result.ok(result.value);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<CollectionCenter>> getCollectionCenterById(String id) async {
    // Retrieves from a VIEW
    final result = await _databaseService.getUserById(
      table: 'full_collection_centers',
      id: id,
    );

    switch (result) {
      case Success<Map<String, dynamic>>():
        final center = CollectionCenter.fromJson(result.value);
        return Result.ok(center);
      case Failure<Map<String, dynamic>>():
        _logger.e('Error: ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<Result<void>> deleteCCenter({required String id}) async {
    try {
      return await _databaseService.deleteUserById(id: id);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<CollectionCenter>>> fetchCCenters() async {
    try {
      final result = await _databaseService.fetchColumnsTable(
        table: 'collection_centers',
        columns: '''id, commercial_name, validation_status, rfc''',
      );
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<CollectionCenter> centers = (result.value as List)
              .map(
                (item) =>
                    CollectionCenter.fromJson(item as Map<String, dynamic>),
              )
              .toList();

          return Result.ok(centers);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> updateCCenter(CollectionCenter editedCenter) async {
    try {
      return await _databaseService.updateFullUser(editedCenter);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(error);
    }
  }

  // For read private PDF docs
  Future<Result<String?>> getTemporaryUrl(String path) async {
    return await _databaseService.getTemporaryUrl(path);
  }

  Future<Result<void>> changeValidationStatus(String status, String id) async {
    final result = await _databaseService.updateData(
      table: 'collection_centers',
      map: <String, dynamic>{"validation_status": status},
      id: id
    );
  return result;
  }
}
