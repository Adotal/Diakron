import 'package:diakron_collectors/models/waste_collection/waste_collection.dart';
import 'package:diakron_collectors/ui/core/ui/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CollectionDetailScreen extends StatelessWidget {
  const CollectionDetailScreen({super.key, required this.collection});

  final WasteCollection collection;

  @override
  Widget build(BuildContext context) {
    final bool isComplete = collection.isComplete;

    // Formateadores
    final df = DateFormat('dd/MM/yyyy HH:mm');
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return CustomScreen(
      title: "Detalle de Recolección",

      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ESTADO DE LA RECOLECCIÓN
            _buildStatusHeader(isComplete),
            const SizedBox(height: 20),

            // INFORMACIÓN BÁSICA
            _buildSectionCard(
              title: "Información General",
              icon: Icons.info_outline,
              children: [
                _detailRow("ID Registro", "#${collection.id}"),
                _detailRow(
                  "Tipo de Residuo",
                  _getWasteName(collection.idWasteType),
                ),
                _detailRow("ID Segregador", "${collection.idSegregator}"),
                _detailRow("Fecha Recolección", df.format(collection.collDate)),
              ],
            ),

            const SizedBox(height: 20),

            // DETALLES DE ENTREGA (Solo si isComplete es true) ---
            if (isComplete)
              _buildSectionCard(
                title: "Detalles de Entrega y Pago",
                icon: Icons.receipt_long_outlined,
                children: [
                  _detailRow(
                    "Centro de Acopio",
                    collection.ccenterName ?? "N/A",
                  ),
                  _detailRow(
                    "Peso",
                    "${(collection.massGrams ?? 0) / 1000} kg",
                  ),
                  _detailRow(
                    "Fecha de Pago",
                    collection.paymentDate != null
                        ? df.format(collection.paymentDate!)
                        : "Pendiente",
                  ),
                  const Divider(height: 30),
                  _detailRow(
                    "Monto Bruto",
                    currency.format(collection.bruteAmount ?? 0),
                  ),
                  _detailRow(
                    "Comisión Diakron",
                    "- ${currency.format(collection.commission ?? 0)}",
                    isNegative: true,
                  ),
                  _detailRow(
                    "Monto Neto",
                    currency.format(collection.netAmount ?? 0),
                    isBold: true,
                    valueColor: const Color(0xFF38761D),
                  ),
                ],
              )
            else
              // Mensaje informativo si no está completado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.pending_actions, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Esta recolección aún no ha sido entregada en un centro de acopio.",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para el encabezado de estado (Badge)
  Widget _buildStatusHeader(bool isComplete) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: isComplete
            ? const Color(0xFF00C853).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isComplete ? const Color(0xFF00C853) : Colors.grey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.access_time_filled,
            color: isComplete ? const Color(0xFF00C853) : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isComplete ? "RECOLECCIÓN COMPLETADA" : "PENDIENTE DE ENTREGA",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isComplete
                  ? const Color(0xFF00C853)
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Widget de tarjeta contenedora
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF38761D), size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          ...children,
        ],
      ),
    );
  }

  // Widget para cada fila de información
  Widget _detailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    bool isNegative = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: 15,
              color: isNegative ? Colors.red : (valueColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para traducir IDs a nombres (puedes mover esto a una utilidad)
  String _getWasteName(int id) {
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
}
