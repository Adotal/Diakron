import 'package:flutter/material.dart';

class ValidationStatus {
  static const String uploading = 'UPLOADING';
  static const String pending = 'PENDING';
  static const String approved = 'APPROVED';
  static const String denied = 'DENIED';
}

// Extension to make UI code look beautiful
extension ValidationStatusX on String? {
  
  Color get statusColor {
    switch (this?.toUpperCase()) {
      case ValidationStatus.approved: return Colors.green;
      case ValidationStatus.denied: return Colors.red;
      case ValidationStatus.pending: return Colors.orange;
      case ValidationStatus.uploading: return Colors.blue;
      default: return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (this?.toUpperCase()) {
      case ValidationStatus.approved: return Icons.check_circle;
      case ValidationStatus.denied: return Icons.error;
      case ValidationStatus.pending: return Icons.hourglass_empty;
      case ValidationStatus.uploading: return Icons.cloud_upload;
      default: return Icons.help_outline;
    }
  }

  String get statusLabel {
    switch (this?.toUpperCase()) {
      case ValidationStatus.approved: return "Aprobado";
      case ValidationStatus.denied: return "Rechazado";
      case ValidationStatus.pending: return "Pendiente";
      case ValidationStatus.uploading: return "Subiendo...";
      default: return "Desconocido";
    }
  }
}