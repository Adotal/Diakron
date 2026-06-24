import 'dart:convert';
import 'package:diakron_participant/data/repositories/auth/auth_repository.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class QRCouponViewmodel extends ChangeNotifier {
  QRCouponViewmodel({
    required AuthRepository authRepository,
    required this.userId,
    required this.couponId,
  }) : _authRepository = authRepository {
    load = Command0(_load)..execute();
  }

  final _logger = Logger();

  final String userId;
  final int couponId;
  String? payload;
  final AuthRepository _authRepository;

  late final Command0 load;

  Future<Result<void>> _load() async {
    try {
      /*
    Concatenar todo para el QR
    Concepto  -   BYTES     -    HEX (characters)
    UUID      -   16            32
    couponId  -   2         -   4
    timestamp -   3         -   6
    nonce     -   8         -   16
    sign      -   64        -   128
    Total     -   93        -   186

    Base64    -   121
    
    */
      payload = await getSecureQRPayload(couponId);
      _logger.e(payload);
      return Result.ok(null);
    } catch (e) {
      _logger.e(e);
      return Result.error(Exception(e));
    }
  }

  Future<String> getSecureQRPayload(int couponId) async {
    // Obtener la sesión actual de Supabase
    final session = _authRepository.currentSession;

    if (session == null) {
      throw Exception('Usuario no autenticado. Por favor, inicia sesión.');
    }

    // Extraer el token JWT
    final String userAuthToken = session.accessToken;

    _logger.i('JWT: $userAuthToken, $couponId');

    const url = 'https://diakron-backend.onrender.com/gen-qr';

    
    // Hacer la petición con el token en la cabecera
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userAuthToken',
      },
      body: jsonEncode({'couponId': couponId}),
    );

    if (response.statusCode == 200) {
      final jsonRes = jsonDecode(response.body);
      return jsonRes['qrData']; // El Base64 listo para QrImageView
    } else {
      final errorMsg =
          jsonDecode(response.body)['error'] ?? 'Error desconocido';
      throw Exception('Fallo al generar QR: $errorMsg');
    }
  }
}
