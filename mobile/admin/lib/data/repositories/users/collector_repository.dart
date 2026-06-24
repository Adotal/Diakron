import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/models/segregator/segregator.dart';
import 'package:diakron_admin/models/users/collector/collector.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';

class CollectorRepository {
  CollectorRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();

  Future<Result<void>> updateCollector(Collector editedCollector) async {
    try {
      return await _databaseService.updateFullUser(editedCollector);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteUserById({required String id}) async {
    return await _databaseService.deleteUserById(id: id);
  }

  Future<Result<Collector>> getCollectorById(String id) async {
    // Retrieves from a VIEW
    final result = await _databaseService.getUserById(
      table: 'full_collectors',
      id: id,
    );

    switch (result) {
      case Success<Map<String, dynamic>>():
        final center = Collector.fromJson(result.value);
        return Result.ok(center);
      case Failure<Map<String, dynamic>>():
        _logger.e('Error: ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<Result<void>> deleteCollector({required String id}) async {
    try {
      return await _databaseService.deleteUserById(id: id);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> changeActiveStatus(bool isActive, String id) async {
    final result = await _databaseService.updateData(
      table: 'users',
      map: <String, dynamic>{"is_active": isActive},
      id: id,
    );
    return result;
  }

  Future<Result<List<Collector>>> fetchCollectors() async {
    try {
      final result = await _databaseService.fetchColumnsTable(
        table: 'full_collectors',
        columns: '''id, user_name, is_active''',
      );
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Collector> centers = (result.value as List)
              .map((item) => Collector.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(centers);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
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
}
