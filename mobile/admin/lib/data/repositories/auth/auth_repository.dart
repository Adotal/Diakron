import 'dart:io';

import 'package:diakron_admin/data/services/auth_service.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository extends ChangeNotifier {
  // Dependency injection
  AuthRepository({required AuthService authService})
    : _authService = authService {
    _initListener();
  }

  final AuthService _authService;

  bool get isAuthenticated => (_authService.currentSession != null);
  bool _isRecoveringPassword = false;
  bool get isRecoveringPassword => _isRecoveringPassword;

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

    try {
      await _authService.updatePassword(password: password);

      return const Result.ok(null);
    } on AuthWeakPasswordException catch (_) {
      // Contraseña no cumple los requisitos de Supabase
      return Result.error(
        DisplayableException(
          'La contraseña es muy débil. Debe tener al menos 8 caracteres, una letra mayúscula, una minúscula, un número y un carácter especial.',
        ),
      );
    } on AuthException catch (e) {
      // Otros errores específicos de Supabase durante la actualización
      if (e.message.contains('same password') ||
          e.message.contains('different')) {
        return Result.error(
          DisplayableException(
            'La nueva contraseña debe ser diferente a la anterior.',
          ),
        );
      } else if (e.message.contains('expired') ||
          e.message.contains('session')) {
        return Result.error(
          DisplayableException(
            'Tu enlace o sesión ha expirado. Por favor, solicita la recuperación de nuevo.',
          ),
        );
      } else if (e.statusCode == '429') {
        return Result.error(
          DisplayableException(
            'Demasiados intentos. Por favor intenta más tarde.',
          ),
        );
      }

      // Fallback para errores de Auth generales
      return Result.error(
        DisplayableException(
          'No se pudo actualizar la contraseña: ${e.message}',
        ),
      );
    } on SocketException {
      // Falla de red (import 'dart:io';)
      return Result.error(
        DisplayableException(
          'No hay conexión a internet. Revisa tu red e intenta de nuevo.',
        ),
      );
    } catch (e) {
      // Convertimos el error a String para inspeccionarlo
      final errorString = e.toString();

      // Atrapamos cualquier variación de error de red o falta de internet
      if (errorString.contains('SocketException') ||
          errorString.contains('Failed host lookup') ||
          errorString.contains('ClientException')) {
        return Result.error(
          DisplayableException(
            'No hay conexión a internet. Revisa tu red e intenta de nuevo.',
          ),
        );
      }

      // Si no es un error de red, entonces sí es un error inesperado real
      return Result.error(
        DisplayableException(
          'Error inesperado al comunicarse con el servidor.',
        ),
      );
    } finally {
      // Esto garantiza que tu UI nunca se quede congelada cargando infinitamente.
      _isRecoveringPassword = false;
      notifyListeners();
    }
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
    try {
      await _authService.sendEmailforgetPassword(email: email);
      return const Result.ok(null);
    } catch (e) {
      return Result.error(DisplayableException('Error al enviar solicitud'));
    }
  }


  String? getCurrentUserEmail() => _authService.getEmail();
}
