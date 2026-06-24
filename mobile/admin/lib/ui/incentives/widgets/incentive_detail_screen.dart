import 'dart:io';
import 'package:diakron_admin/models/incentive/incentive.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncentiveDetailScreen extends StatefulWidget {
  const IncentiveDetailScreen({super.key, required this.incentive});

  final Incentive incentive;

  @override
  State<IncentiveDetailScreen> createState() => _IncentiveDetailScreenState();
}

class _IncentiveDetailScreenState extends State<IncentiveDetailScreen> {  
  final DateFormat df = DateFormat('dd/MM/yyyy HH:mm');
  final NumberFormat currency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "Detalle de Recolección",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // INFORMACIÓN BÁSICA
            _buildSectionCard(
              title: "Información de pago General",
              icon: Icons.info_outline,
              children: [
                _detailRow("ID Registro", "#${widget.incentive.id}"),
                _detailRow(
                  "Monto Bruto",
                  currency.format(widget.incentive.amount),
                ),
                _detailRow(
                  "Fecha de pago",
                  df.format(widget.incentive.createdAt.toLocal()),
                ),
              ],
            ),

            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Detalles de Tienda",
              icon: Icons.receipt_long_outlined,
              children: [
                _detailRow(
                  "Tienda",
                  widget.incentive.storeCommercialName ?? "N/A",
                ),
                _detailRow(
                  "Porcentaje de representación",
                  "${widget.incentive.repPercentage} %",
                ),

                _detailRow(
                  "Puntos totales adquiridos por la tienda",
                  "${widget.incentive.storePointsExchanged}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // Helpers UI
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

}
