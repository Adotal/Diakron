// home_viewmodel.dart
import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/users/collection_center.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AuthRepository authRepository,
    required CCenterRepository ccenterRepository,
  }) : _authRepository = authRepository,
       _ccenterRepository = ccenterRepository {
    load = Command0(_load);
  }


  final AuthRepository _authRepository;
  final CCenterRepository _ccenterRepository;

  late final Command0 load;
  CollectionCenter? _collectionCenter;
  CollectionCenter get collectionCenter => _collectionCenter!;

  final _logger = Logger();

  Future<Result<void>> _load() async {
    try {
      final result = await _ccenterRepository.getCollectionCenter();

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

}
