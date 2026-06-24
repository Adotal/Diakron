import 'package:diakron_participant/data/repositories/auth/auth_repository.dart';
import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/result.dart';

class LogoutViewModel {
  LogoutViewModel({
    required AuthRepository authRepository,
    required ParticipantRepository participantRepository,
  }) : _authRepository = authRepository,
       _participantRepository = participantRepository {
    // Command0 is used because logout doesn't require input parameters
    logout = Command0<void>(_logout);
  }

  final AuthRepository _authRepository;
  final ParticipantRepository _participantRepository;
  late Command0 logout;

  Future<Result<void>> _logout() async {
    _participantRepository.clearCache();
    return await _authRepository.logout();
  }
}
