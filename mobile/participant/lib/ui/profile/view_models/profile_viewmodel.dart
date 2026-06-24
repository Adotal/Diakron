import 'package:diakron_participant/data/repositories/auth/auth_repository.dart';
import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/models/user_waste_stats/user_waste_stats.dart';
import 'package:diakron_participant/models/users/participant.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/displayable_exception.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:diakron_participant/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileViewmodel extends ChangeNotifier {
  ProfileViewmodel({
    required ParticipantRepository participantRepository,
    required AuthRepository authRepository,
  }) : _participantRepository = participantRepository,
       _authRepository = authRepository {
    // Command0 is used because logout doesn't require input parameters
    load = Command0<void>(_load);
    logout = Command0<void>(_logout);
    deleteAccount = Command0<void>(_deleteAccount);
    updateField = Command1<void, (String jsonKey, dynamic newValue)>(
      _updateField,
    );
  }

  final ParticipantRepository _participantRepository;
  final AuthRepository _authRepository;
  late final Command0 load;
  late final Command0<void> logout;
  late final Command0 deleteAccount;
  late final Command1 updateField;

  Participant? _participant;
  Participant? get participant => _participant;

  final _logger = Logger();

  UserWasteStats? _userWasteStats;
  UserWasteStats get userWasteStats => _userWasteStats!;

  bool? isEmpty;

  Future<Result> _load() async {
    try {
      final result = await _participantRepository.getParticipant();
      switch (result) {
        case Success<Participant>():
          _participant = result.value;
          _logger.i(_participant.toString());
        case Failure<Participant>():
          _logger.e(result.error);
          return result;
      }

      final resultUWS = await _participantRepository.getUserWS();

      switch (resultUWS) {
        case Success<UserWasteStats>():
          _userWasteStats = resultUWS.value;
          _logger.i(_userWasteStats);
        case Failure<UserWasteStats>():
          _logger.e(resultUWS.error);
      }

      return resultUWS;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _logout() async {
    // Empty cached user
    _participantRepository.clearCache();
    return await _authRepository.logout();
  }

  Future<Result<void>> _deleteAccount() async {
    final result = await _participantRepository.deleteUserById(
      id: participant!.id,
    );
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
    final previousParticipantState = participant;

    // If newValue is null or empty, nothing to do
    if (newValue == null || newValue == '') {
      _participant = previousParticipantState;
      notifyListeners();
      return Result.error(
        DisplayableException('No puedes dejar campos vacíos'),
      );
    }

    // 'OPTIMIST UPDATE'
    // Actualizamos la UI al instante dependiendo del campo modificado.
    switch (jsonKey) {
      case 'phone_number':
        _participant = participant!.copyWith(phoneNumber: newValue as String);
        final String? isValid = Validators.phoneNumber(newValue);
        if (isValid != null) {
          _participant = previousParticipantState;
          notifyListeners();
          return Result.error(DisplayableException(isValid));
        }
        break;
      case 'user_name':
        _participant = participant!.copyWith(userName: newValue as String);
        break;
      case 'surnames':
        _participant = participant!.copyWith(surnames: newValue as String);
        break;
      // Agrega otros campos si los haces editables
    }

    // Notificamos a la UI para que se redibuje con el nuevo valor al instante
    notifyListeners();

    // ENVIAR AL BACKEND (PATCH)
    final Map<String, dynamic> dataToUpdate = {jsonKey: newValue};

    final result = await _participantRepository.updateParticipant(
      participantId: participant!.id,
      dataToUpdate: dataToUpdate,
    );

    switch (result) {
      case Success<void>():
        _logger.i("Successfully $jsonKey");
        break;
      case Failure<void>():
        _participant = previousParticipantState;
        notifyListeners();
        // Aquí puedes mostrar un SnackBar de error
        _logger.e("Error actualizando $jsonKey: ${result.error}");
        break;
    }

    return result;
  }
}
