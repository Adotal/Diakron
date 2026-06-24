import 'dart:io';
import 'package:diakron_collection_center/models/waste_collection/waste_collection.dart';
import 'package:diakron_collection_center/ui/core/ui/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CollectionDetailScreen extends StatefulWidget {
  const CollectionDetailScreen({super.key, required this.collection});

  final WasteCollection collection;

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  bool _isGeneratingPdf = false;
  String? _downloadedPdfPath; // Guarda la ruta cuando se descarga

  final DateFormat df = DateFormat('dd/MM/yyyy HH:mm');
  final NumberFormat currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    _checkIfPdfExists();
  }

  // Busca si existe el archivo PDF en el almacenamiento interno
  Future<void> _checkIfPdfExists() async {
    try {
      final output = await getApplicationDocumentsDirectory();
      // Usamos exactamente el mismo nombre que le dimos al crearlo
      final expectedPath = "${output.path}/recibo_diakron_${widget.collection.id}.pdf";
      final file = File(expectedPath);

      // Si el archivo existe físicamente, restauramos la ruta y la UI cambia a Verde
      if (await file.exists()) {
        setState(() {
          _downloadedPdfPath = expectedPath;
        });
      }
    } catch (e) {
      debugPrint("Error buscando PDF existente: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isComplete = widget.collection.isComplete;

    return CustomScreen(
      title: "Detalle de Recolección",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // BOTÓN / ESTADO DE LA RECOLECCIÓN
            _buildPdfButton(isComplete),
            const SizedBox(height: 20),

            // INFORMACIÓN BÁSICA
            _buildSectionCard(
              title: "Información General",
              icon: Icons.info_outline,
              children: [
                _detailRow("ID Registro", "#${widget.collection.id}"),
                _detailRow("Tipo de Residuo", _getWasteName(widget.collection.idWasteType)),
                _detailRow("ID Segregador", "${widget.collection.idSegregator}"),
                _detailRow("Fecha Recolección", df.format(widget.collection.collDate.toLocal())),
                _detailRow("Recolector", "${widget.collection.collectorName} ${widget.collection.collectorSurnames}"),
              ],
            ),

            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Detalles de Entrega y Pago",
              icon: Icons.receipt_long_outlined,
              children: [
                _detailRow("Centro de Acopio", widget.collection.ccenterName ?? "N/A"),
                _detailRow("Peso", "${(widget.collection.massGrams ?? 0) / 1000} kg"),
                _detailRow(
                  "Fecha de Pago",
                  widget.collection.paymentDate != null
                      ? df.format(widget.collection.paymentDate!.toLocal())
                      : "Pendiente",
                ),
                const Divider(height: 30),
                _detailRow("Monto Bruto", currency.format(widget.collection.bruteAmount ?? 0)),
                _detailRow(
                  "Comisión Diakron",
                  "- ${currency.format(widget.collection.commission ?? 0)}",
                  isNegative: true,
                ),
                _detailRow(
                  "Monto Neto",
                  currency.format(widget.collection.netAmount ?? 0),
                  isBold: true,
                  valueColor: const Color(0xFF38761D),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET DEL BOTÓN (Interactivo) ---
  Widget _buildPdfButton(bool isComplete) {
    if (!isComplete) {
      return _badgeContainer(
        text: 'RECOLECCIÓN PENDIENTE',
        icon: Icons.hourglass_empty,
        color: Colors.grey,
      );
    }

    if (_isGeneratingPdf) {
      return _badgeContainer(
        text: 'GENERANDO PDF...',
        icon: Icons.sync,
        color: Colors.blue,
        isSpinning: true,
      );
    }

    final hasPdf = _downloadedPdfPath != null;

    return GestureDetector(
      onTap: hasPdf ? _openPdf : _generateAndSavePdf,
      child: _badgeContainer(
        text: hasPdf ? 'VER PDF' : 'DESCARGAR REPORTE PDF',
        icon: hasPdf ? Icons.visibility : Icons.download,
        color: hasPdf ? const Color(0xFF00C853) : Colors.blueAccent, // Cambia a verde al descargar
      ),
    );
  }

  Widget _badgeContainer({
    required String text,
    required IconData icon,
    required Color color,
    bool isSpinning = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isSpinning
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color),
                )
              : Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE PDF ---
  Future<void> _generateAndSavePdf() async {
    setState(() => _isGeneratingPdf = true);

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Reporte de Recoleccion - Diakron',
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                pw.SizedBox(height: 20),

                // Sección 1
                pw.Text('Informacion General', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                _pdfRow('ID Registro:', '#${widget.collection.id}'),
                _pdfRow('Tipo de Residuo:', _getWasteName(widget.collection.idWasteType)),
                _pdfRow('ID Segregador:', '${widget.collection.idSegregator}'),
                _pdfRow('Fecha Recoleccion:', df.format(widget.collection.collDate)),
                _pdfRow('Recolector:', '${widget.collection.collectorName} ${widget.collection.collectorSurnames}'),
                pw.SizedBox(height: 30),

                // Sección 2
                pw.Text('Detalles de Entrega y Pago', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Divider(),
                _pdfRow('Centro de Acopio:', widget.collection.ccenterName ?? "N/A"),
                _pdfRow('Ubicación', widget.collection.ccenterAddress ?? "N/A"),
                _pdfRow('Peso:', '${(widget.collection.massGrams ?? 0) / 1000} kg'),
                _pdfRow('Fecha de Pago:', widget.collection.paymentDate != null ? df.format(widget.collection.paymentDate!) : "Pendiente"),
                pw.SizedBox(height: 15),
                _pdfRow('Monto Bruto:', currency.format(widget.collection.bruteAmount ?? 0)),
                _pdfRow('Comision Diakron:', '- ${currency.format(widget.collection.commission ?? 0)}', isRed: true),
                pw.Divider(),
                _pdfRow('Monto Neto:', currency.format(widget.collection.netAmount ?? 0), isBold: true, isGreen: true),
              ],
            );
          },
        ),
      );

      // Guardar el archivo en el dispositivo
      final output = await getApplicationDocumentsDirectory();
      final file = File("${output.path}/recibo_diakron_${widget.collection.id}.pdf");
      print('\n\n\nPATH: ${file.path} \n\n\n');
      await file.writeAsBytes(await pdf.save());

      // Actualizar estado para mostrar "Ver PDF"
      setState(() {
        _downloadedPdfPath = file.path;
      });

    } catch (e) {
      debugPrint("Error generando PDF: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al generar el PDF')),
        );
      }
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _openPdf() async {
    if (_downloadedPdfPath != null) {
      final result = await OpenFilex.open(_downloadedPdfPath!);
      if (result.type != ResultType.done && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el archivo: ${result.message}')),
        );
      }
    }
  }

  // --- HELPER PARA DIBUJAR FILAS EN EL PDF ---
  pw.Widget _pdfRow(String label, String value, {bool isBold = false, bool isRed = false, bool isGreen = false}) {
    PdfColor valueColor = PdfColors.black;
    if (isRed) valueColor = PdfColors.red;
    if (isGreen) valueColor = PdfColors.green800;

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: const pw.TextStyle(color: PdfColors.grey700)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Helpers UI
  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF38761D), size: 22),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false, Color? valueColor, bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
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

  String _getWasteName(int id) {
    switch (id) {
      case 1: return "Plástico";
      case 2: return "Metal";
      case 3: return "Vidrio";
      case 4: return "Papel/Cartón";
      default: return "Otros";
    }
  }
}