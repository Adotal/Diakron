import 'dart:convert';
import 'package:diakron_participant/data/repositories/auth/auth_repository.dart';
import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/models/drop_waste/deposito.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:logger/web.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/foundation.dart';

// FUTURE MOVE TO ITS OWN REPOSITORY
import 'package:http/http.dart' as http;

// FUTURE MOVE COUPON INFO AND USER REPO TO OTHER WIDGET

// Excepción personalizada para limpiar el mensaje en la UI
class QrException implements Exception {
  final String message;
  QrException(this.message);

  @override
  String toString() => message; // Retorna SOLO el texto
}

class ScannerViewModel extends ChangeNotifier {
  ScannerViewModel({
    required AuthRepository authRepository,
    required ParticipantRepository participantRepository,
  }) : _participantRepository = participantRepository,
       _authRepository = authRepository {
    verifyQR = Command1<void, Uint8List>(_verifyQR);
  }

  final AuthRepository _authRepository;
  final ParticipantRepository _participantRepository;
  late final Command1<void, Uint8List> verifyQR;
  Barcode? _barcode;
  final _logger = Logger();
  int? _points;
  int get points => _points!;
  Deposito? _deposito;
  Deposito get deposito => _deposito!;

  Future<Result<void>> _verifyQR(Uint8List payload) async {
    // Obtener la sesión actual de Supabase
    final session = _authRepository.currentSession;

    if (session == null) {
      throw Exception('Usuario no autenticado. Por favor, inicia sesión.');
    }

    // Extraer el token JWT
    final String userAuthToken = session.accessToken;
    // _logger.i('JWT: $userAuthToken');
    printWrapped('JWT: $userAuthToken');

    const url = 'https://diakron-backend.onrender.com/verify-qr';

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

        _logger.i('Points: ${data['points']}');
        _points = data['points'];
        // Extract coupon ID
        extractPoints(payload);

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

  void extractPoints(Uint8List payload) {
    // Get couponId

    _deposito = Deposito(qrPayload: payload);

    _logger.i(deposito.toString());

    // ByteData byteData = ByteData.sublistView(payload.sublist(16, 18));
    // //  Read as a 16-bit unsigned integer
    // _points = byteData.getUint16(0, Endian.big);
    // _logger.i(_points);
  }

  void handleBarcode(BarcodeCapture barcodes) {
    // Evitar spam de peticiones si ya está procesando un QR
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


  // TESTING AUXILIAR FOR PRINT JWT, DELETE IS SAFE
  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}