import 'dart:io';

import 'package:diakron_participant/data/services/auth_service.dart';
import 'package:diakron_participant/utils/displayable_exception.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository({required AuthService authService})
    : _authService = authService {
    _initListener();
  }

  final AuthService _authService;

  bool get isAuthenticated => (_authService.currentSession != null);
  bool _isRecoveringPassword = false;
  bool get isRecoveringPassword => _isRecoveringPassword;
  Session? get currentSession => _authService.currentSession;

  // State flag to freeze the router during check of USER TYPE and for permit ANIMATION
  bool _isVerifyingAuth = false;
  bool get isVerifyingAuth => _isVerifyingAuth;

  void _initListener() {
    _authService.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        _isRecoveringPassword = true;
      } else if (event == AuthChangeEvent.signedIn) {
        if (!_isRecoveringPassword) {
          _isRecoveringPassword = false;
        }
      } else if (event == AuthChangeEvent.signedOut) {
        _isRecoveringPassword = false;
      }

      notifyListeners();
    });
  }

  // Adjust return type to match what AuthService actually returns
  Future<Result<void>> login(String email, String password) async {
    _isVerifyingAuth = true;
    notifyListeners();

    try {
      // Try login, if error will go to catch satements
      await _authService.signInWithPassword(email: email, password: password);

      return const Result.ok(null);
    } on AuthException catch (e) {
      // Mapeo de errores específicos de Supabase
      if (e.message.contains('Invalid login credentials')) {
        return Result.error(
          DisplayableException('Correo o contraseña inválidos'),
        );
      } else if (e.message.contains('Email not confirmed')) {
        return Result.error(
          DisplayableException('Verifica tu correo antes de iniciar sesión'),
        );
      } else if (e.statusCode == '429') {
        return Result.error(
          DisplayableException(
            'Demasiados intentos. Por favor intenta después',
          ),
        );
      }
      return Result.error(
        DisplayableException('Autenticación fallida, intente de nuevo'),
      );
    } on DisplayableException catch (e) {
      // Aquí atrapamos el error "Credenciales inválidas" si el usuario NO era admin
      return Result.error(e);
    } on SocketException {
      // Sin internet
      return Result.error(DisplayableException('No hay conexión a internet'));
    } catch (e) {
      // Cualquier otro crash (errores de Dart, etc.)
      return Result.error(
        DisplayableException('Un error inesperado ha ocurrido'),
      );
    }
  }

  void lockRouter() {
    _isVerifyingAuth = true;
  }

  void unlockRouter() {
    _isVerifyingAuth = false;
    notifyListeners();
  }

  Future<Result<void>> signUp({
    required String username,
    required String surnames,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    // Lock router to manually sign in and force user to login and see animation
    lockRouter();

    try {
      await _authService.sigUpEmailPassword(
        username: username,
        surnames: surnames,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      return const Result.ok(null);
    } on AuthWeakPasswordException catch (_) {
      // Ignoramos el mensaje nativo y creamos uno amigable para el humano
      return Result.error(
        DisplayableException(
          'La contraseña es muy débil. Debe tener al menos 8 caracteres, una letra mayúscula, una minúscula, un número y un carácter especial.',
        ),
      );

      //  Atrapamos errores generales de Auth
    } on AuthException catch (e) {
      // Manejamos el caso clásico de "El correo ya existe"
      if (e.message.contains('already registered') ||
          e.message.contains('User already exists')) {
        return Result.error(
          DisplayableException(
            'Este correo ya está registrado. Intenta iniciar sesión.',
          ),
        );
      }

      // Fallback para otros errores de Supabase
      return Result.error(
        DisplayableException('No se pudo crear la cuenta: ${e.message}'),
      );

      // 3. Fallas de red o hardware
    } on SocketException {
      return Result.error(
        DisplayableException('No hay conexión a internet. Revisa tu red.'),
      );

      // 4. Cualquier otro crash inesperado
    } catch (e) {
      return Result.error(
        DisplayableException(
          'Ocurrió un error inesperado al intentar registrarte.',
        ),
      );
    }
  }

  Future<Result<void>> updatePassword({required String password}) async {
    // Lock router to manually sign in and force user to login and see animation
    lockRouter();

    final result = await _authService.updatePassword(password: password);
    _isRecoveringPassword = false;
    if (result is Failure<UserResponse>) {
      return Result.error(result.error);
    }

    return Result.ok(null);
  }

  // In auth_repository.dart
  Future<Result<void>> logout() async {
    try {
      await _authService.signOut();
      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<void>> sendEmailforgetPassword({required String email}) async {
    final result = await _authService.sendEmailforgetPassword(email: email);
    if (result is Failure) {
      return Result.error(result.error);
    }
    return Result.ok(null);
  }

  String? getCurrentUserEmail() => _authService.getEmail();
}
