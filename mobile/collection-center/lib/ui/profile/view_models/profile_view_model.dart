import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/users/collection_center.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required AuthRepository authRepository,
    required CCenterRepository cCenterRepository,
  }) : _authRepository = authRepository,
       _cCenterRepository = cCenterRepository {
    // Command0 is used because logout doesn't require input parameters
    load = Command0(_load);
    logout = Command0<void>(_logout);
  }

  final AuthRepository _authRepository;
  final CCenterRepository _cCenterRepository;
  late final Command0 load;
  CollectionCenter? _collectionCenter;
  CollectionCenter get collector => _collectionCenter!;
  final _logger = Logger();
  late final Command0<void> logout;

  Future<Result<void>> _load() async {
    try {
      final result = await _cCenterRepository.getCollectionCenter();

      switch (result) {
        case Success<CollectionCenter>():
          _collectionCenter = result.value;
          _logger.i("Cached collector $_collectionCenter");
        case Failure<CollectionCenter>():
          _logger.e('Error fetching collector');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _logout() async {
    return await _authRepository.logout();
  }
}
