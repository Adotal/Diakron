import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart'; // For defaultTargetPlatform
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

class LocationService {
  StreamSubscription<Position>? _positionStream;

  final _logger = Logger();

  Future<bool> startTracking({required String userId, required String fcmToken}) async {
    // Revisar estado y permisos
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
    }

    // Configurar Background Service según el OS
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Monitoreando segregadores cercanos...",
          notificationTitle: "Diakron Recolector Activo",
          enableWakeLock: true,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 10,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true, 
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    // Iniciar Stream
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      _logger.i("Location Update: ${position.latitude}, ${position.longitude}");
      _sendLocationToBackend(
        lat: position.latitude, 
        lon: position.longitude, 
        userId: userId, 
        fcmToken: fcmToken
      );
    });

    return true;
  }

  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _logger.w("Tracking detenido");
  }

  Future<void> _sendLocationToBackend({
    required double lat, 
    required double lon, 
    required String userId, 
    required String fcmToken
  }) async {
    final url = Uri.parse('https://diakron-backend.onrender.com/update-location');    
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'lat': lat,
          'lon': lon,
          'fcmToken': fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        _logger.i("Ubicación enviada correctamente");
      }
    } catch (e) {
      _logger.i('Network Error: $e');
    }
  }
}