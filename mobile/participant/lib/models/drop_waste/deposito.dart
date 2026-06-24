import 'dart:typed_data';

class Deposito {
  // Using 'int' for all numeric values; Dart handles 8, 16, and 32-bit uints easily.
  final int id;
  final int metalCount;
  final int metalWeight;
  final int plasticCount;
  final int plasticWeight;
  final int paperCount;
  final int paperWeight;
  final int glassCount;
  final int glassWeight;
  final int timestamp;
  final int nonce;
  final Uint8List signature;

  // Constructor with Initializer List
  Deposito({required Uint8List qrPayload})
      : assert(qrPayload.length >= 88, "Payload must be at least 88 bytes"),
        // We wrap the bytes in ByteData to read multi-byte integers correctly
        id = ByteData.sublistView(qrPayload, 0, 2).getUint16(0),
        metalCount = qrPayload[2],
        metalWeight = ByteData.sublistView(qrPayload, 3, 5).getUint16(0),
        plasticCount = qrPayload[5],
        plasticWeight = ByteData.sublistView(qrPayload, 6, 8).getUint16(0),
        
        paperCount = qrPayload[8],
        paperWeight = ByteData.sublistView(qrPayload, 9, 11).getUint16(0),
        glassCount = qrPayload[11],
        glassWeight = ByteData.sublistView(qrPayload, 12, 14).getUint16(0),
        timestamp = ByteData.sublistView(qrPayload, 14, 18).getUint32(0),
        nonce = ByteData.sublistView(qrPayload, 18, 26).getUint64(0),
        signature = qrPayload.sublist(26, 90);

  // To display data in UI
  @override
  String toString() {
    return 
    // 'id: $id \n'
    '\n'
    'Metal: $metalCount ($metalWeight g)\n'
    'Plastic: $plasticCount ($plasticWeight g)\n'
    'Glass: $glassCount ($glassWeight g)\n'
    'Paper: $paperCount ($paperWeight g)\n';
    // 'timestamp: $timestamp\n'
    // 'nonce: $nonce\n';
  }
}