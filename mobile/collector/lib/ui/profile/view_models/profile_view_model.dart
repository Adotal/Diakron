import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/data/repositories/user/collector_repository.dart';
import 'package:diakron_collectors/models/users/collector.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required AuthRepository authRepository,
    required CollectorRepository collectorRepository,
  }) : _authRepository = authRepository,
       _collectorRepository = collectorRepository {
    // Command0 is used because logout doesn't require input parameters
    load = Command0(_load);
    logout = Command0<void>(_logout);
  }

  final AuthRepository _authRepository;
  final CollectorRepository _collectorRepository;
  late final Command0 load;
  Collector? _collector;
  Collector get collector => _collector!;
  final _logger = Logger();
  late final Command0<void> logout;
  bool get isMpLinked => collector.mpAccessToken != null && collector.mpAccessToken!.isNotEmpty;

  Future<Result<void>> _load() async {
    try {
      final result = await _collectorRepository.getCollector();

      switch (result) {
        case Success<Collector>():
          _collector = result.value;
          _logger.i("Cached collector ${_collectorRepository.cachedCollector}");
        case Failure<Collector>():
          _logger.e('Error fetching collector');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _logout() async {
    _collectorRepository.clear();
    return await _authRepository.logout();
  }
}