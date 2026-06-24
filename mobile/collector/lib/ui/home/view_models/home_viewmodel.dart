// home_viewmodel.dart
import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/data/repositories/user/collector_repository.dart';
import 'package:diakron_collectors/data/services/location_service.dart';
import 'package:diakron_collectors/data/services/notification_service.dart';
import 'package:diakron_collectors/models/users/collector.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required AuthRepository authRepository,
    required LocationService locationService,
    required CollectorRepository collectorRepository,
  }) : _authRepository = authRepository,
       _locationService = locationService,
       _collectorRepository = collectorRepository {
    // Command0 is used because logout doesn't require input parameters
    load = Command0(_load);
    setTrackingStatus = Command1<void, bool>(_setTrackingStatus);
  }
  // Estado para controlar el toggle (false = Inactivo, true = Activo)
  bool _isActive = false;
  bool get isActive => _isActive;

  final AuthRepository _authRepository;
  final CollectorRepository _collectorRepository;
  final LocationService _locationService;
  
  final _logger = Logger();
  // Nuevo estado: Para mostrar un loading mientras carga el GPS/Token
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  late final Command1 setTrackingStatus;
  late final Command0 load;
  Collector? _collector;
  Collector get collector => _collector!;

  Future<Result<void>> _load() async {
    try {
      final result = await _collectorRepository.getCollector(        
      );

      switch (result) {
        case Success<Collector>():
          _collector = result.value;
          _logger.i("Cached collector $_collector");
        case Failure<Collector>():
          _logger.e('Error fetching collector');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  // Centralizamos la lógica de encendido y apagado
  Future<Result<void>> _setTrackingStatus(bool enable) async {
    // Si ya está en el estado deseado, no hacemos nada
    if (_isActive == enable) return Result.ok(null);

    try {
      _isLoading = true;
      notifyListeners(); // Actualiza la UI para mostrar un posible loading

      if (enable) {
        // INTENTAR ENCENDER EL RASTREO
        String? token = await NotificationService.getToken();

        if (token != null) {
          String userId = _authRepository.userId;

          bool success = await _locationService.startTracking(
            userId: userId,
            fcmToken: token,
          );

          if (success) {
            _isActive = true;
            _logger.i("¡Rastreo iniciado en segundo plano!");
          } else {
            // Si el usuario denegó permisos, success es false.
            // Lo mantenemos inactivo.
            _isActive = false;
            _logger.i("No se pudo iniciar el rastreo (sin permisos)");
            return Result.error(Exception("No location active "));
          }
        }
      } else {
        // APAGAR EL RASTREO
        _locationService.stopTracking();
        _isActive = false;
        _logger.i("¡Rastreo detenido!");
      }
      return Result.ok(null);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
