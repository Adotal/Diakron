import 'package:diakron_participant/data/repositories/auth/auth_repository.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/displayable_exception.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ResetPasswordViewmodel extends ChangeNotifier {
  ResetPasswordViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    updatePassword = Command1<void, (String password, String confirmPassword)>(
      _updatePassword,
    );
  }

  final AuthRepository _authRepository;
  final _logger = Logger();
  late Command1 updatePassword;

  Future<Result<void>> _updatePassword((String, String) passwords) async {
    final (password, confirmPassword) = passwords;

    if (password != confirmPassword ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      return Result.error(
        DisplayableException(
          'Las contraseñas no coinciden o el campo está vacío',
        ),
      );
    }

    final result = await _authRepository.updatePassword(password: password);

    switch (result) {
      case Success<void>():      
        return const Result.ok(null);        
      case Failure<void>():
        _logger.e(result.error);
        return Result.error(result.error);
    }
  }
}
