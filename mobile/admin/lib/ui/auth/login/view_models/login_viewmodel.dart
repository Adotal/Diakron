import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:diakron_admin/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command1<void, (String email, String password)>(_login);
  }

  final AuthRepository _authRepository;
  late Command1 login;

  final Logger _logger = Logger();

  Future<Result<void>> _login((String, String) credentials) async {
    final (email, password) = credentials;

    if (email == '') {
      return Result.error(DisplayableException('No se ingresó ningún correo'));
    }

    final String? isEmailValid = Validators.email(email);
    if (isEmailValid != null) {
      return Result.error(DisplayableException(isEmailValid));
    }

    final result = await _authRepository.login(email, password);

    if (result is Failure) {
      _logger.w('Login failed for $email: ${result.error}');
    } else {
      _logger.d('Success!\nEmail:$email');
    }

    return result;
  }
}
