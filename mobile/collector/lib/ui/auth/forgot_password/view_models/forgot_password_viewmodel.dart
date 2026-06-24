import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ForgotPasswordViewmodel extends ChangeNotifier {
  ForgotPasswordViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    sendRecoverEmail = Command1<void, String>(_sendRecoverEmail);
  }

  final AuthRepository _authRepository;
  late Command1 sendRecoverEmail;
  final _logger = Logger();

  Future<Result<void>> _sendRecoverEmail(String email) async {

    if(email == ''){
      return Result.error(Exception('No email specified'));
    }

    final result = await _authRepository.sendEmailforgetPassword(email: email);
    if (result is Failure) {
      _logger.e(result.error);
      return Result.error(result.error);
    }

    // await Future.delayed(Duration(seconds: 2));
    _logger.i("Recover email to $email");
    return Result.ok(null);  
  }
}
