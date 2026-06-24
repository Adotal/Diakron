import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class StatsViewModel extends ChangeNotifier {
  StatsViewModel({required CCenterRepository ccenterRepository})
      : _ccenterRepository = ccenterRepository {
    load = Command0(_load)..execute();
  }

  final CCenterRepository _ccenterRepository;
  late Command0 load;
  final _logger = Logger();

  // 1. Cambiamos el tipo a List<Map<String, dynamic>>
  List<Map<String, dynamic>> _collectionWeights = [];
  List<Map<String, dynamic>> get collectionWeights => _collectionWeights;

  Future<Result<void>> _load() async {
    try {
      await _ccenterRepository.getCollectionCenter(forceRefresh: true);

      final resultUWS = await _ccenterRepository.geCollectionWeights();

      switch (resultUWS) {
        case Success<List<Map<String, dynamic>>>():
          _logger.i(resultUWS.value);
          // 2. ¡IMPORTANTE! Asignamos el valor para que la UI reaccione
          _collectionWeights = resultUWS.value; 
          return Result.ok(null);
        case Failure<List<Map<String, dynamic>>>():
          _logger.e(resultUWS.error);
          return Result.error(resultUWS.error);
      }
    } finally {
      notifyListeners();
    }
  }
}