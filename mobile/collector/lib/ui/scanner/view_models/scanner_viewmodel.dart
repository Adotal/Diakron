import 'dart:convert';
import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/data/repositories/user/collector_repository.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
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
    required CollectorRepository collectorRepository,
    required AuthRepository authRepository,
  }) : _userRepository = collectorRepository,
       _authRepository = authRepository {
    verifyQR = Command1<void, Uint8List>(_verifyQR);
  }

  final CollectorRepository _userRepository;
  final AuthRepository _authRepository;

  late final Command1<void, Uint8List> verifyQR;
  Barcode? _barcode;
  final _logger = Logger();

  // 'Set' because it can appears only once each value
  final Set<String> _selectedMaterials = {};
  Set<String> get selectedMaterials => _selectedMaterials;

  bool _isScanning = false; // Controla si mostramos el selector o la cámara
  bool get isScanning => _isScanning;

  final List<String> materials = [
    'Metal',
    'Plástico',
    'Papel/Cartón',
    'Vidrio',
  ];

  // Alternar selección (Si está, lo quita; si no, lo pone)
  void toggleMaterial(String material) {
    if (_selectedMaterials.contains(material)) {
      _selectedMaterials.remove(material);
    } else {
      _selectedMaterials.add(material);
    }
    notifyListeners();
  }

  void startScanning() {
    _logger.i(selectedMaterials.toString());
    if (_selectedMaterials.isNotEmpty) {
      _isScanning = true;
      notifyListeners();
    }
  }  

  void resetSelection() {
    _isScanning = false;
    _selectedMaterials.clear();
    verifyQR.clearResult();
    notifyListeners();
  }

  Future<Result<void>> _verifyQR(Uint8List payload) async {
    // Obtener la sesión actual de Supabase
    final session = _authRepository.currentSession;

    if (session == null) {
      throw Exception('Usuario no autenticado. Por favor, inicia sesión.');
    }

    // Extraer el token JWT
    final String userAuthToken = session.accessToken;

    _logger.i('JWT: $userAuthToken');

    const url = 'https://diakron-backend.onrender.com/verify-qr-collector';
    // const url = 'http://192.168.100.135:3000/verify-qr-collector';

    /*
      Añadir tipos de materiales al payload
      Operadores bit a bit (Bitwise OR)
      0001  - Metal
      0010  - Plastic 
      0100  - Paper/Cardboard
      1000  - Glass

    
    */
    int materialsByte = 0; // 0000 0000 en binario
    if (_selectedMaterials.contains(materials[0])) {
      materialsByte |= 1; // 0000 0001
    }
    if (_selectedMaterials.contains(materials[1])) {
      materialsByte |= 2; // 0000 0010
    }
    if (_selectedMaterials.contains(materials[2])) {
      materialsByte |= 4; // 0000 0100
    }
    if (_selectedMaterials.contains(materials[3])) {
      materialsByte |= 8; // 0000 1000
    }

    // Crear un nuevo arreglo que sea 1 byte más grande que el payload original
    final combinedPayload = Uint8List(payload.length + 1);

    // Colocar el byte de materiales en la primera posición (índice 0)
    combinedPayload[0] = materialsByte;

    // Copiar el payload original empezando desde la posición 1
    combinedPayload.setAll(1, payload);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/octet-stream',
          'Authorization': 'Bearer $userAuthToken',
        },
        body: combinedPayload,
      );

      // Si el backend regresa un JSON, lo parseamos
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['valid'] == true) {
        _logger.i('Binary data sent successfully!');

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
}
