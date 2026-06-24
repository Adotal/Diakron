import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/models/users/participant/participant.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';

class ParticipantRepository {
  ParticipantRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();


  Future<Result<void>> updateParticipant(Participant editedParticipant) async {
    try {
      return await _databaseService.updateFullUser(editedParticipant);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteUserById({required String id}) async {
    return await _databaseService.deleteUserById(id: id);
  }

  Future<Result<Participant>> getParticipantById(String id) async {
    // Retrieves from a VIEW
    final result = await _databaseService.getUserById(
      table: 'full_participants',
      id: id,
    );

    switch (result) {
      case Success<Map<String, dynamic>>():
        final center = Participant.fromJson(result.value);
        return Result.ok(center);
      case Failure<Map<String, dynamic>>():
        _logger.e('Error: ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<Result<void>> deleteParticipant({required String id}) async {
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

    Future<Result<List<Participant>>> fetchParticipants() async {
    try {
      final result = await _databaseService.fetchColumnsTable(
        table: 'full_participants',
        columns: '''id, user_name, points, is_active''',
      );
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Participant> centers = (result.value as List)
              .map((item) => Participant.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(centers);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
