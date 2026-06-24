import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:diakron_admin/utils/validation/validators.dart';
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
    if (email == '') {
      return Result.error(DisplayableException('No se ingresó ningún correo'));
    }

    final String? isEmailValid = Validators.email(email);
    if (isEmailValid != null) {
      return Result.error(DisplayableException(isEmailValid));
    }

    final result = await _authRepository.sendEmailforgetPassword(email: email);

    switch (result) {
      case Success<void>():
        _logger.i("Recover email to $email");
        return Result.ok(null);
      case Failure<void>():
        _logger.e(result.error);
        return Result.error(result.error);
    }
  }
}
