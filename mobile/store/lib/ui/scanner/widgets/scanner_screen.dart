import 'package:diakron_stores/models/coupon/coupon.dart';
import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/custom_screen.dart';
import 'package:diakron_stores/ui/core/ui/error_indicator.dart';
import 'package:diakron_stores/ui/core/ui/success_indicator.dart';
import 'package:diakron_stores/ui/scanner/view_models/scanner_viewmodel.dart';
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
      title: 'Escanear QR de canjeo',
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
              // context.go(SuccessExchangeIndicator as String);
              return Center(                
                child: Column(
                  children: [
                    SizedBox(height: Dimens.paddingVertical,),
                    SuccessIndicator(
                      title:
                          '¡Canje registrado exitosamente!\nPuedes entregar el siguiente beneficio al cliente',
                      label: 'Escanear otra vez',
                      onPressed: () => verifyCommand.clearResult(),
                    ),
                
                    ListenableBuilder(
                      listenable: widget.viewModel.loadCoupon,
                      builder: (context, child) {
                        if (widget.viewModel.loadCoupon.running) {
                          return const Center(child: CircularProgressIndicator());
                        }
                
                        if (widget.viewModel.loadCoupon.error) {
                          return Center(
                            child: ErrorIndicator(
                              title: 'Error loading Coupon Info',
                              label: 'Try again',
                              onPressed: widget.viewModel.loadCoupon.execute,
                            ),
                          );
                        }
                
                        final coupon = widget.viewModel.coupon!;
                        return buildCouponCard(coupon);
                      },
                    ),
                  ],
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

  Widget buildCouponCard(Coupon coupon) {
    return Padding(      
      padding: const EdgeInsets.all(30.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, // Asegura que la imagen respete el redondeo
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Alinea texto a la izquierda
          children: [
            _buildHeaderImage(coupon),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon.descript,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(Coupon coupon) {
    return SizedBox(
      width: double.infinity, // Ocupa todo el ancho disponible
      height: 180, // Un poco más alto para impacto visual
      child: Image.network(
        coupon.urlImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
