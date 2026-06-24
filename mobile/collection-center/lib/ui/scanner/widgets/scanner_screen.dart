import 'package:diakron_collection_center/ui/core/ui/custom_screen.dart';
import 'package:diakron_collection_center/ui/core/ui/error_indicator.dart';
import 'package:diakron_collection_center/ui/core/ui/success_indicator.dart';
import 'package:diakron_collection_center/ui/scanner/view_models/scanner_viewmodel.dart';
import 'package:diakron_collection_center/ui/scanner/widgets/payment_form.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.viewModel});

  final ScannerViewModel viewModel;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Registrar recolección',
      child: SafeArea(
        child: ListenableBuilder(
          listenable: widget.viewModel.verifyQR,
          builder: (context, _) {
            final verifyCommand = widget.viewModel.verifyQR;
            if (verifyCommand.running) {
              return const Center(child: CircularProgressIndicator());
            }

            if (verifyCommand.error) {
              // Ajustar error
              final errorMessage = verifyCommand.result.toString();

              return ErrorIndicator(
                title: errorMessage,
                label: 'Escanear otra vez',
                onPressed: () => verifyCommand.clearResult(),
              );
            }

            if (verifyCommand.completed) {
              if (verifyCommand.completed) {
                // Si el pago aún no se ha realizado, mostramos el formulario
                // if (!widget.viewModel.paymentCompleted) {
                return SingleChildScrollView(
                  child: DeliveryPaymentForm(
                    viewModel: widget.viewModel,
                  ),
                );
              }

              // Si el pago ya se completó, mostramos el SuccessIndicator
              return Center(
                child: SuccessIndicator(
                  title:
                      '¡Pago de \$${widget.viewModel.totalAmount} realizado!',
                  label: 'Escanear otro QR',
                  onPressed: () {
                    verifyCommand.clearResult();
                    widget.viewModel.resetPayment();
                  },
                ),
              );
            }

            return Stack(
              children: [
                MobileScanner(onDetect: widget.viewModel.handleBarcode),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(
                      20,
                    ), // Preferible sobre EdgeInsetsGeometry.all
                    color: const Color.fromRGBO(0, 0, 0, 0.4),
                    // Eliminado el Row vacío para limpiar el árbol de widgets
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
