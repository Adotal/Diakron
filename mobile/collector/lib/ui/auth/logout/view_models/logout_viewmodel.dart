import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';

class LogoutViewModel {
  LogoutViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    // Command0 is used because logout doesn't require input parameters
    logout = Command0<void>(_logout);
  }

  final AuthRepository _authRepository;
  late Command0 logout;


  Future<Result<void>> _logout() async {
    return await _authRepository.logout();
  }
}