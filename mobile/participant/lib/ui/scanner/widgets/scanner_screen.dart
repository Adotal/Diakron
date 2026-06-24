import 'package:diakron_participant/ui/core/themes/colors.dart';
import 'package:diakron_participant/ui/core/ui/error_indicator.dart';
import 'package:diakron_participant/ui/core/ui/success_indicator.dart';
import 'package:diakron_participant/ui/scanner/view_models/scanner_viewmodel.dart';
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
  return Scaffold(
    backgroundColor: const Color(0xFFF5F7FA),

    body: ListenableBuilder(
      listenable: widget.viewModel.verifyQR,

      builder: (context, _) {
        final verifyCommand =
            widget.viewModel.verifyQR;

        if (verifyCommand.running) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (verifyCommand.error) {
          return ErrorIndicator(
            title: verifyCommand.result.toString(),

            label: 'Escanear otra vez',

            onPressed: () =>
                verifyCommand.clearResult(),
          );
        }

        if (verifyCommand.completed) {
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.all(24),

              child: SuccessIndicator(
                title:
                    '¡${widget.viewModel.points} puntos registrados exitosamente!\n\n${widget.viewModel.deposito}',

                label: 'Escanear otra vez',

                onPressed: () =>
                    verifyCommand.clearResult(),
              ),
            ),
          );
        }

        return Column(
          children: [
            _buildHeader(),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),

                child: Column(
                  children: [
                    Expanded(
                      child:
                          _buildScannerCard(),
                    ),

                    const SizedBox(height: 20),

                    _buildBottomInfoCard(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget _buildHeader() {
  final topPadding =
      MediaQuery.of(context).padding.top;

  return Container(
    width: double.infinity,

    padding: EdgeInsets.fromLTRB(
      20,
      topPadding + 20,
      20,
      30,
    ),

    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.greenDiakron4,
          AppColors.greenDiakron1,
        ],

        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),

      borderRadius: BorderRadius.vertical( // Borde header verde
        bottom: Radius.circular(0),
      ),
    ),

    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Escanear QR',

              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Registra depósitos y gana puntos',

              style: TextStyle(
                color:
                    Colors.white.withOpacity(0.9),

                fontSize: 14,
              ),
            ),
          ],
        ),

        Container(
          width: 52,
          height: 52,

          decoration: BoxDecoration(
            color:
                Colors.white.withOpacity(0.18),

            shape: BoxShape.circle,
          ),

          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    ),
  );
}

Widget _buildScannerCard() {
  return Container(
    width: double.infinity,

    decoration: BoxDecoration(
      color: Colors.black,

      borderRadius:
          BorderRadius.circular(30),

      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withOpacity(0.12),

          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),

    child: Stack(
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(30),

          child: MobileScanner(
            onDetect:
                widget.viewModel.handleBarcode,
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color:
                Colors.black.withOpacity(0.35),

            borderRadius:
                BorderRadius.circular(30),
          ),
        ),

        Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              const Text(
                'Coloca el código dentro del marco',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              _buildScannerFrame(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildBottomInfoCard() {
  return Container(
    width: double.infinity,

    padding: const EdgeInsets.all(20),

    decoration: BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(24),

      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withOpacity(0.04),

          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),

    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          width: 50,
          height: 50,

          decoration: BoxDecoration(
            color:
                AppColors.greenDiakron1
                    .withOpacity(0.1),

            borderRadius:
                BorderRadius.circular(14),
          ),

          child: const Icon(
            Icons.qr_code_scanner,

            color: AppColors.greenDiakron1,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                'Consejo',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Mantén estable la cámara y asegúrate de tener buena iluminación para un escaneo rápido.',

                style: TextStyle(
                  color: Colors.grey.shade600,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



  Widget _buildScannerFrame() {
  return Container(
    width: 260,
    height: 260,

    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: Colors.white.withOpacity(0.15),
        width: 2,
      ),
    ),

    child: Stack(
      children: [
        // TOP LEFT
        _scannerCorner(
          Alignment.topLeft,
          true,
          true,
        ),

        // TOP RIGHT
        _scannerCorner(
          Alignment.topRight,
          false,
          true,
        ),

        // BOTTOM LEFT
        _scannerCorner(
          Alignment.bottomLeft,
          true,
          false,
        ),

        // BOTTOM RIGHT
        _scannerCorner(
          Alignment.bottomRight,
          false,
          false,
        ),
      ],
    ),
  );
}

Widget _scannerCorner(
  Alignment alignment,
  bool left,
  bool top,
) {
  return Align(
    alignment: alignment,

    child: Container(
      width: 45,
      height: 45,

      decoration: BoxDecoration(
        border: Border(
          left: left
              ? const BorderSide(
                  color: Colors.white,
                  width: 5,
                )
              : BorderSide.none,

          right: !left
              ? const BorderSide(
                  color: Colors.white,
                  width: 5,
                )
              : BorderSide.none,

          top: top
              ? const BorderSide(
                  color: Colors.white,
                  width: 5,
                )
              : BorderSide.none,

          bottom: !top
              ? const BorderSide(
                  color: Colors.white,
                  width: 5,
                )
              : BorderSide.none,
        ),

        borderRadius:
            BorderRadius.circular(12),
      ),
    ),
  );
}


}
