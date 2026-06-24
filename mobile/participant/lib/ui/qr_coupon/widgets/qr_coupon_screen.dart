import 'package:diakron_participant/ui/core/ui/custom_screen.dart';
import 'package:diakron_participant/ui/core/ui/error_indicator.dart';
import 'package:diakron_participant/ui/qr_coupon/view_models/qr_coupon_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCouponScreen extends StatefulWidget {
  const QRCouponScreen({super.key, required this.viewModel});

  final QRCouponViewmodel viewModel;

  @override
  State<QRCouponScreen> createState() => _QRCouponScreenState();
}

class _QRCouponScreenState extends State<QRCouponScreen> {
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
                title: 'Error creando QR',
                label: 'Regenerar qR',
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

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: widget.viewModel.payload!,
                      version: QrVersions.auto,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                      size: size,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(20),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "¡Muestra este código QR en el negocio para obtener tu recompensa!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
