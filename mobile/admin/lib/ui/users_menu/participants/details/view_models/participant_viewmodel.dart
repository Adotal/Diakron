import 'package:diakron_admin/data/repositories/users/participant_repository.dart';
import 'package:diakron_admin/models/users/participant/participant.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class ParticipantDetailsViewModel extends ChangeNotifier {
  ParticipantDetailsViewModel({
    required ParticipantRepository participantsRepository,
    required this.participantId,
  }) : _participantRepository = participantsRepository {
    load = Command0(_load)..execute();
    deleteParticipant = Command0(_deleteParticipant);
    updateParticipant = Command0(_updateParticipant);
    changeValidationStatus = Command1(_changeActiveStatus);
  }

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      editedParticipant = participant;
    }
    notifyListeners();
  }

  final ParticipantRepository _participantRepository;
  final String participantId;

  late Command0 load;
  late Command0 deleteParticipant;
  late Command0 updateParticipant;
  late Command1<void, bool> changeValidationStatus;
  Participant? participant;
  Participant? editedParticipant;

  final _logger = Logger();

  Future<Result<void>> _changeActiveStatus(bool isActive) async {
    _logger.i('New $isActive\n $participantId');
    try {
      final result = await _participantRepository.changeActiveStatus(
        isActive,
        participantId,
      );

      switch (result) {
        case Success<void>():
          _logger.i('Changed status to $isActive');
        case Failure<void>():
          _logger.e('ERROR CHANGING STATUS ${result.error}');
      }

      // Reload
      load.execute();
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _updateParticipant() async {
    try {
      final result = await _participantRepository.updateParticipant(editedParticipant!);

      switch (result) {
        case Success<void>():
          _logger.i('Updated Participants successfully');
        case Failure<void>():
          _logger.e('ERROR UPDATING Participants');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _load() async {
    try {
      // Fetch fresh data for this specific participants
      final result = await _participantRepository.getParticipantById(participantId);

      switch (result) {
        case Success<Participant>():
          participant = result.value;
          _logger.d(participant);
        case Failure<Participant>():
          return result;
      }

      return result;
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteParticipant() async {
    try {
      final result = await _participantRepository.deleteParticipant(id: participantId);
      switch (result) {
        case Success<void>():
          _logger.i('Successfully deleted participants');
        case Failure<void>():
          _logger.e('Error deleted participants');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
