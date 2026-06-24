import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/displayable_exception.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class SignupViewModel extends ChangeNotifier {
  SignupViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    signup =
        Command1<
          void,
          (
            String userName,
            String surnames,
            String email,
            String phoneNumber,
            String password,
            String confirmPassword,
          )
        >(_signUp);
  }

  final AuthRepository _authRepository;
  final Logger _logger = Logger();

  late Command1 signup;

  Future<Result<void>> _signUp(
    (String, String, String, String, String, String) data,
  ) async {
    final (userName, surnames, email, phoneNumber, password, confirmPassword) =
        data;

    _logger.i("Email:$email\nPsw:$password\nconfPsw:$confirmPassword");

    if (password != confirmPassword ||
        password == '' ||
        confirmPassword == '') {
      return Result.error(DisplayableException('Las contraseñas no coinciden'));
    }

    // Try to sign up
    final result = await _authRepository.signUp(
      username: userName,
      surnames: surnames,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );

    switch (result) {
      case Success<void>():
        _logger.i('Signup successful');
        return Result.ok(null);
      case Failure<void>():
        _logger.e('Error signup> ${result.error}');
        return Result.error(result.error);
    }
  }
}
