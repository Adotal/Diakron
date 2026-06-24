import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
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
    final result = await _authRepository.login(email, password);

    if (result is Failure) {
      _logger.w('Login failed for $email: ${result.error}');
    } else {
      _logger.d('Success!\nEmail:$email');
    }

    return result;
  }
}
