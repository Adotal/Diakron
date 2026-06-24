import 'dart:convert';
import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/waste_collection/waste_collection.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/displayable_exception.dart';
import 'package:diakron_collection_center/utils/result.dart';
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
    required CCenterRepository ccenterRepository,
  }) : _ccenterRepository = ccenterRepository,
       _authRepository = authRepository {
    verifyQR = Command1<void, Uint8List>(_verifyQR);
    fetchCollection = Command0(_fetchCollection);
    payment = Command0(_executePayment);
  }

  final AuthRepository _authRepository;
  final CCenterRepository _ccenterRepository;
  late final Command1<void, Uint8List> verifyQR;
  late final Command0<void> fetchCollection;
  Barcode? _barcode;
  final _logger = Logger();
  bool _isCash = false;
  bool get isCash => _isCash;

  int? _collectionId;
  WasteCollection? _collection;
  WasteCollection get collection => _collection!;

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

    const url = 'https://diakron-backend.onrender.com/verify-qr-collection-center';
  

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
        _collectionId = data['collectionId'];
        _logger.i('QR is valid!');
        _logger.i('CollectionID: $_collectionId ');

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

  // ---------------------FUNCTIONS FOR PAYMENT_FORM --------------
  // FUTURE MOVE TO ITS OWN VIEWMODEL, THE UNIQUE SHARED RESOURCE IS _collection object

  // En ScannerViewModel
  double massGr = 0;
  double priceKg = 0;
  double get priceGr => priceKg / 1000;

  // Cálculo reactivo
  double get totalAmount => massGr * priceGr;
  double get paymentCollector => massGr * priceGr * 0.80;
  double get paymentDiakron => massGr * priceGr * 0.20;

  // Comando para pagar (asumiendo que usas la misma estructura de Command)
  late final Command0 payment;

  bool get canPay => massGr > 0 && priceKg > 0;

  String? _checkoutURL;
  String get checkoutURL => _checkoutURL!;

  void updateMass(String value) {
    massGr = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void updatePrice(String value) {
    priceKg = double.tryParse(value) ?? 0;
    notifyListeners();
  }

  void resetPayment() {
    massGr = priceKg = 0;
    _collection = null;
  }

  Future<Result<void>> _fetchCollection() async {
    try {
      // FETCH COUPON
      final result = await _ccenterRepository.fetchCollection(
        idCollection: '${_collectionId!}',
      );
      switch (result) {
        case Success<WasteCollection>():
          _collection = result.value;          
          _logger.i(_collection);       
          if(collection.isComplete)   {
            return Result.error(DisplayableException("Recolección ya completada"));
          }
          return Result.ok(null);
        case Failure<WasteCollection>():
          _logger.e(result.error);
          return result;
      }
    } finally {
      notifyListeners();
    }
  }

  // Helper para traducir IDs a nombres (puedes mover esto a una utilidad)
  String getWasteName(int id) {
    switch (id) {
      case 1:
        return "Plástico";
      case 2:
        return "Metal";
      case 3:
        return "Vidrio";
      case 4:
        return "Papel/Cartón";
      default:
        return "Otros";
    }
  }

  Future<Result<void>> _executePayment() async {

    // Assures collection ID is retrieved
    await _ccenterRepository.getCollectionCenter(forceRefresh: true);

    // First gets preference from backend
    const url = 'https://diakron-backend.onrender.com/payment-ccenter';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        // ENVIAMOS EL PRECIO REAL
        body: jsonEncode({
          'amount': totalAmount,
          'material': getWasteName(_collection!.idWasteType),
          'mass': massGr,
          'collectionId': _collectionId,
          'ccenterId': _ccenterRepository.ccenter.id,
          'collectorId': _collection!.idCollector,
          'isCash': _isCash,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _checkoutURL = data['initPoint'];
        _logger.i('Preferencia obtenida: $checkoutURL');        
        return Result.ok(null);
      } else {
        _logger.e('Error del servidor: ${response.body}');
        return Result.error(Exception(response.body));
      }
    } on Exception catch (error) {
      _logger.e('Fallo de conexión: $error');
      return Result.error(error);
    }
  }

  void toggleIsCash(){
    _isCash = !_isCash;
    notifyListeners();
  }
}
