import 'package:diakron_admin/data/repositories/users/collector_repository.dart';
import 'package:diakron_admin/models/users/collector/collector.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class CollectorDetailsViewModel extends ChangeNotifier {
  CollectorDetailsViewModel({
    required CollectorRepository collectorsRepository,
    required this.collectorId,
  }) : _collectorRepository = collectorsRepository {
    load = Command0(_load)..execute();
    deleteCollector = Command0(_deleteCollector);
    updateCollector = Command0(_updateCollector);
    changeValidationStatus = Command1(_changeActiveStatus);
  }

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      editedCollector = collector;
    }
    notifyListeners();
  }

  final CollectorRepository _collectorRepository;
  final String collectorId;

  late Command0 load;
  late Command0 deleteCollector;
  late Command0 updateCollector;
  late Command1<void, bool> changeValidationStatus;
  Collector? collector;
  Collector? editedCollector;

  final _logger = Logger();

  Future<Result<void>> _changeActiveStatus(bool isActive) async {
    _logger.i('New $isActive\n $collectorId');
    try {
      final result = await _collectorRepository.changeActiveStatus(
        isActive,
        collectorId,
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

  Future<Result> _updateCollector() async {
    try {
      final result = await _collectorRepository.updateCollector(editedCollector!);

      switch (result) {
        case Success<void>():
          _logger.i('Updated Collectors successfully');
        case Failure<void>():
          _logger.e('ERROR UPDATING Collectors');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _load() async {
    try {
      // Fetch fresh data for this specific collectors
      final result = await _collectorRepository.getCollectorById(collectorId);

      switch (result) {
        case Success<Collector>():
          collector = result.value;
          _logger.d(collector);
        case Failure<Collector>():
          return result;
      }

      return result;
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteCollector() async {
    try {
      final result = await _collectorRepository.deleteCollector(id: collectorId);
      switch (result) {
        case Success<void>():
          _logger.i('Successfully deleted collectors');
        case Failure<void>():
          _logger.e('Error deleted collectors');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
