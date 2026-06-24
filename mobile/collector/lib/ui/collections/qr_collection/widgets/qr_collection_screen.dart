import 'package:diakron_collectors/ui/collections/qr_collection/view_models/qr_collection_view_model.dart';
import 'package:diakron_collectors/ui/core/ui/custom_screen.dart';
import 'package:diakron_collectors/ui/core/ui/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCollectionScreen extends StatefulWidget {
  const QRCollectionScreen({super.key, required this.viewModel});

  final QRCollectionViewModel viewModel;

  @override
  State<QRCollectionScreen> createState() => _QRCollectionScreenState();
}

class _QRCollectionScreenState extends State<QRCollectionScreen> {

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'QR',
      child: Center(
        child: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, _) {
            if (widget.viewModel.load.running) {
              return CircularProgressIndicator();
            }

            if (widget.viewModel.load.error) {
              final error = widget.viewModel.load.result;
              return ErrorIndicator(
                title: 'Error recuperando QR',
                label: 'Recargar QR',
                onPressed: widget.viewModel.load.execute,
              );
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                // Buscamos la dimensión más pequeña (ancho o alto) para mantener el QR cuadrado
                final double size = constraints.maxWidth < constraints.maxHeight
                    ? constraints.maxWidth *
                          0.9 // 90% del ancho
                    : constraints.maxHeight *
                          0.7; // 70% del alto (para dejar espacio al texto)

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageView(
                        data: widget.viewModel.payload!,
                        version: QrVersions.auto,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                        size: size,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "¡Muestra este código QR en el centro de acopio para entregar la recolección!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Text('El codigó caducará en 24 horas depués de su generación',
                      textAlign: TextAlign.center,)
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
