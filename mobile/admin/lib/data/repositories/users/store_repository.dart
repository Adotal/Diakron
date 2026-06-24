import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/models/users/store/store.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';

class StoreRepository {
  StoreRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();

  Future<Result<Store>> getStoreById(String id) async {
    // Retrieves from a VIEW
    final result = await _databaseService.getUserById(
      table: 'full_stores',
      id: id,
    );

    switch (result) {
      case Success<Map<String, dynamic>>():
        final center = Store.fromJson(result.value);
        return Result.ok(center);
      case Failure<Map<String, dynamic>>():
        _logger.e('Error: ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<Result<int>> getTotalPoints() async {
    try {
      final result = await _databaseService.getTotalPoints();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<int>> getTotalComissions() async {
    try {
      final result = await _databaseService.getTotalComissions();
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Store>>> fetchStores() async {
    try {
      final result = await _databaseService.fetchColumnsTable(
        table: 'stores',
        columns:
            '''id, commercial_name, points_exchanged, validation_status, rfc''',
      );
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Store> centers = (result.value as List)
              .map((item) => Store.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(centers);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> changeValidationStatus(String status, String id) async {
    final result = await _databaseService.updateData(
      table: 'stores',
      map: <String, dynamic>{"validation_status": status},
      id: id,
    );
    return result;
  }

  Future<Result<void>> updateStore(Store editedCenter) async {
    try {
      return await _databaseService.updateFullUser(editedCenter);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteStore({required String id}) async {
    try {
      return await _databaseService.deleteUserById(id: id);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<String?>> getTemporaryUrl(String path) async {
    return await _databaseService.getTemporaryUrl(path);
  }
}
