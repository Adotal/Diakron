import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/displayable_exception.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:diakron_stores/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileViewmodel extends ChangeNotifier {
  ProfileViewmodel({
    required StoreRepository storeRepository,
    required AuthRepository authRepository,
  }) : _storeRepository = storeRepository,
       _authRepository = authRepository {    // Command0 is used because logout doesn't require input parameters
    load = Command0<void>(_load);
    logout = Command0<void>(_logout);
    deleteAccount = Command0<void>(_deleteAccount);
    updateField = Command1<void, (String jsonKey, dynamic newValue)>(
      _updateField,
    );
  }
  final StoreRepository _storeRepository;
  final AuthRepository _authRepository;
  late final Command0 load;
  late final Command0<void> logout;
  late final Command0 deleteAccount;
  late final Command1 updateField;
  Store? _store;
  Store get store => _store!;  
  final _logger = Logger();

  bool get isMpLinked => store.mpAccessToken != null && store.mpAccessToken!.isNotEmpty;
  Future<Result> _load() async {
    try {
      final result = await _storeRepository.getStore();
      switch (result) {
        case Success<Store>():
          _store = result.value;

          _logger.w(_store.toString());
          return Result.ok('value');
        case Failure<Store>():
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _logout() async {
    // Empty cached user
    _storeRepository.clearCache();

    return await _authRepository.logout();
  }

  Future<Result<void>> _deleteAccount() async {
    final result = await _storeRepository.deleteUserById(id: store.id!);
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
    final previousstoreState = store;

    // If newValue is null or empty, nothing to do
    if (newValue == null || newValue == '') {
      _store = previousstoreState;
      notifyListeners();
      return Result.error(
        DisplayableException('No puedes dejar campos vacíos'),
      );
    }

    // 'OPTIMIST UPDATE'
    // Actualizamos la UI al instante dependiendo del campo modificado.
    switch (jsonKey) {
      case 'phone_number':
        _store = store.copyWith(phoneNumber: newValue as String);
        final String? isValid = Validators.phoneNumber(newValue);
        if (isValid != null) {
          _store = previousstoreState;
          notifyListeners();
          return Result.error(DisplayableException(isValid));
        }
        break;
      case 'user_name':
        _store = store.copyWith(userName: newValue as String);
        break;
      case 'surnames':
        _store = store.copyWith(surnames: newValue as String);
        break;
      // Agrega otros campos si los haces editables
    }

    // Notificamos a la UI para que se redibuje con el nuevo valor al instante
    notifyListeners();

    // ENVIAR AL BACKEND (PATCH)
    final Map<String, dynamic> dataToUpdate = {jsonKey: newValue};

    final result = await _storeRepository.updateStore(
      storeId: store.id!,
      dataToUpdate: dataToUpdate,
    );

    switch (result) {
      case Success<void>():
        _logger.i("Successfully $dataToUpdate");
        break;
      case Failure<void>():
        _store = previousstoreState;
        notifyListeners();
        // Aquí puedes mostrar un SnackBar de error
        _logger.e("Error actualizando $jsonKey: ${result.error}");
        break;
    }

    return result;
  }
}
