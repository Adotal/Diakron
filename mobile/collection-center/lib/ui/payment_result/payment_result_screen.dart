import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/ui/core/ui/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentResultScreen extends StatelessWidget {
  final String status;
  final String? paymentId;
  final String? externalReference;

  const PaymentResultScreen({
    super.key, 
    required this.status, 
    this.paymentId, 
    this.externalReference
  });

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Estado de Pago',
      child:  Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildUI(context),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    switch (status) {
      case 'success':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text('¡Pago Exitoso!', style: Theme.of(context).textTheme.headlineMedium),
            Text('ID de Operación: $paymentId'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go(Routes.home), // Volver al inicio
              child: const Text('Continuar'),
            ),
          ],
        );
      case 'pending':
        return const Center(child: Text('El pago está en proceso...'));
      case 'failure':
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text('El pago fue rechazado o cancelado'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.pop(), // Reintentar
              child: const Text('Volver a intentar'),
            ),
          ],
        );
    }
  }
}