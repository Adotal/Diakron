import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewmodel extends ChangeNotifier {
  ResetPasswordViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    updatePassword = Command1<void, (String password, String confirmPassword)>(
      _updatePassword,
    );
  }

  final AuthRepository _authRepository;

  late Command1 updatePassword;

  Future<Result<void>> _updatePassword((String, String) passwords) async {
    final (password, confirmPassword) = passwords;

    if (password != confirmPassword ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return Result.error(Exception('Passwords empty or dont match'));
    }

    final result = await _authRepository.updatePassword(password: password);

    return result;
  }
}
