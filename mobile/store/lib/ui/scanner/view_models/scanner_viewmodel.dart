import 'dart:convert';
import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:logger/web.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/foundation.dart';

// FUTURE MOVE TO ITS OWN REPOSITORY
import 'package:http/http.dart' as http;

// FUTURE MOVE COUPON INFO AND USER REPO TO OTHER WIDGET

// 1. Excepción personalizada para limpiar el mensaje en la UI
class QrException implements Exception {
  final String message;
  QrException(this.message);

  @override
  String toString() => message; // Retorna SOLO el texto
}

class ScannerViewModel extends ChangeNotifier {
  ScannerViewModel({
    required StoreRepository userRepository,
    required AuthRepository authRepository,
  }) : _userRepository = userRepository,
       _authRepository = authRepository {
    verifyQR = Command1<void, Uint8List>(_verifyQR);
    loadCoupon = Command0(_loadCoupon);
  }

  int? _couponId;
  final StoreRepository _userRepository;
  final AuthRepository _authRepository;

  late final Command1<void, Uint8List> verifyQR;
  Barcode? _barcode;
  final _logger = Logger();

  late final Command0 loadCoupon;
  Coupon? _coupon;
  Coupon? get coupon => _coupon;

  Future<Result<void>> _verifyQR(Uint8List payload) async {
    // Obtener la sesión actual de Supabase
    final session = _authRepository.currentSession;

    if (session == null) {
      throw Exception('Usuario no autenticado. Por favor, inicia sesión.');
    }

    // Extraer el token JWT
    final String userAuthToken = session.accessToken;

    _logger.i('JWT: $userAuthToken');

    const url = 'https://diakron-backend.onrender.com/verify-qr-participant';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/octet-stream',
          'Authorization': 'Bearer $userAuthToken',
        },
        body: payload,
      );

      // Si el backend regresa un JSON, lo parseamos
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['valid'] == true) {
        _logger.i('Binary data sent successfully!');

        // Extract coupon ID
        extractCouponId(payload);
        // Load coupon
        loadCoupon.execute();

        return Result.ok(null);
      }

      // Extraer el mensaje real de error del backend
      // Ajusta la llave 'message' o 'error' según la estructura de tu API en Diakron
      final backendError =
          data['error'] ?? 'Error desconocido al verificar el QR';
      return Result.error(QrException(backendError));
    } catch (error) {
      _logger.e(error);
      return Result.error(QrException('Error de conexión o formato inválido'));
    }
  }

  void extractCouponId(Uint8List payload) {
    // Get couponId

    ByteData byteData = ByteData.sublistView(payload.sublist(16, 18));
    //  Read as a 16-bit unsigned integer
    _couponId = byteData.getUint16(0, Endian.big);
    _logger.i(_couponId);
  }

  void handleBarcode(BarcodeCapture barcodes) {
    // 3. Control de concurrencia: Evitar spam de peticiones si ya está procesando un QR
    if (verifyQR.running) return;

    _barcode = barcodes.barcodes.firstOrNull;
    if (_barcode == null || _barcode!.displayValue == null) return;

    try {
      String base64Payload = _barcode!.displayValue!;
      String normalizedString = base64.normalize(base64Payload);

      _logger.w('Payload normalizado: $normalizedString');

      Uint8List payloadDecoded = base64Decode(normalizedString);
      verifyQR.execute(payloadDecoded);
    } catch (e) {
      _logger.e('Error decodificando el QR: $e');
      // Podrías manejar aquí un error visual si el QR no es un base64 válido
    }
  }

  Future<Result<void>> _loadCoupon() async {
    if (_couponId == null) {
      return Result.error(Exception(null));
    }

    // First load coupon
    final result = await _userRepository.fetchCoupon(couponId: _couponId!);

    switch (result) {
      case Success<Coupon>():
        // Store coupon info
        _coupon = result.value;
        _logger.w(_coupon.toString());
      case Failure<Coupon>():
        _logger.e(result.error);
    }

    return result;
  }
}
