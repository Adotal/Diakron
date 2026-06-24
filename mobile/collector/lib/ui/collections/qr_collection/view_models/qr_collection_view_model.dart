import 'package:diakron_collectors/data/repositories/user/collector_repository.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class QRCollectionViewModel extends ChangeNotifier {
  QRCollectionViewModel({
    required CollectorRepository collectorRepository,
    required this.idCollection,
  }) : _collectorRepository = collectorRepository {
    load = Command0(_load)..execute();
  }

  final _logger = Logger();

  final String idCollection;
  String? payload;
  final CollectorRepository _collectorRepository;

  late final Command0 load;

  // Retrieve QR from DB and store in payload
  Future<Result<void>> _load() async {
    try {
      final result = await _collectorRepository.fetchCollectionQR(
        idCollection: idCollection,
      );

      switch (result) {
        case Success<String>():
          payload = result.value;
          _logger.i("QR Payload: $payload");
          break;
        case Failure<String>():
          _logger.e(result.error);
      }

      return result;
    } catch (e) {
      _logger.e(e);
      return Result.error(Exception(e));
    }
  }

}
