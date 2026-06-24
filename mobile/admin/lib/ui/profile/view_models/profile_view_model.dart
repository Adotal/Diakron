import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/data/repositories/users/admin_repository.dart';
import 'package:diakron_admin/models/users/admin/admin.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:diakron_admin/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required AuthRepository authRepository,
    required AdminRepository adminRepository,
  }) : _authRepository = authRepository,
       _adminRepository = adminRepository {
    // Command0 is used because logout doesn't require input parameters
    load = Command0<void>(_load);
    logout = Command0<void>(_logout);
    deleteAccount = Command0<void>(_deleteAccount);
    updateField = Command1<void, (String jsonKey, dynamic newValue)>(
      _updateField,
    );
  }

  final AuthRepository _authRepository;
  final AdminRepository _adminRepository;
  late final Command0 load;
  late final Command0<void> logout;
  late final Command0 deleteAccount;
  late final Command1 updateField;
  Admin? _admin;
  Admin get admin => _admin!;

  final _logger = Logger();

  Future<Result<void>> _load() async {
    try {
      final result = await _adminRepository.getAdmin();

      switch (result) {
        case Success<Admin>():
          _admin = result.value;
          _logger.i("Cached admin $_admin");
        case Failure<Admin>():
          _logger.e('Error fetching admin');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _logout() async {
    // Empty cached user
    _adminRepository.clearCache();

    return await _authRepository.logout();
  }

  Future<Result<void>> _deleteAccount() async {
    final result = await _adminRepository.deleteUserById(id: admin.id!);
    switch (result) {
      case Success<void>():      
        return Result.ok(null);        
      case Failure<void>():
        _logger.e(result.error);
        return Result.error(DisplayableException('Error eliminando cuenta'));
    }
  }

  Future<Result<void>> _updateField((String, dynamic) data) async {
    final (jsonKey, newValue) = data;
    // Guardamos un respaldo del estado actual por si la API falla
    final previousAdminState = admin;

    // If newValue is null or empty, nothing to do
    if (newValue == null || newValue == '') {
      _admin = previousAdminState;
      notifyListeners();
      return Result.error(
        DisplayableException('No puedes dejar campos vacíos'),
      );
    }

    // 'OPTIMIST UPDATE'
    // Actualizamos la UI al instante dependiendo del campo modificado.
    switch (jsonKey) {
      case 'phone_number':
        _admin = admin.copyWith(phoneNumber: newValue as String);
        final String? isValid = Validators.phoneNumber(newValue);
        if (isValid != null) {
          _admin = previousAdminState;
          notifyListeners();
          return Result.error(DisplayableException(isValid));
        }
        break;
      case 'user_name':
        _admin = admin.copyWith(userName: newValue as String);
        break;
      case 'surnames':
        _admin = admin.copyWith(surnames: newValue as String);
        break;
      // Agrega otros campos si los haces editables
    }

    // Notificamos a la UI para que se redibuje con el nuevo valor al instante
    notifyListeners();

    // ENVIAR AL BACKEND (PATCH)
    final Map<String, dynamic> dataToUpdate = {jsonKey: newValue};

    final result = await _adminRepository.updateAdmin(
      adminId: admin.id!,
      dataToUpdate: dataToUpdate,
    );

    switch (result) {
      case Success<void>():
        _logger.i("Successfully $jsonKey");
        break;
      case Failure<void>():
        _admin = previousAdminState;
        notifyListeners();
        // Aquí puedes mostrar un SnackBar de error
        _logger.e("Error actualizando $jsonKey: ${result.error}");
        break;
    }

    return result;
  }

}
