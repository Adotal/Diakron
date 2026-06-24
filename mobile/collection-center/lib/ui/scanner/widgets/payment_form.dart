import 'package:diakron_collection_center/ui/core/ui/error_indicator.dart';
import 'package:diakron_collection_center/ui/core/ui/form_button.dart';
import 'package:diakron_collection_center/ui/scanner/view_models/scanner_viewmodel.dart';
import 'package:diakron_collection_center/utils/displayable_exception.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:go_router/go_router.dart';

class DeliveryPaymentForm extends StatefulWidget {
  final ScannerViewModel viewModel;

  const DeliveryPaymentForm({super.key, required this.viewModel});

  @override
  State<DeliveryPaymentForm> createState() => _DeliveryPaymentFormState();
}

class _DeliveryPaymentFormState extends State<DeliveryPaymentForm> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchCollection.execute();
    widget.viewModel.payment.addListener(_onPaymentURL);
  }

  @override
  void didUpdateWidget(covariant DeliveryPaymentForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.payment.removeListener(_onPaymentURL);
    widget.viewModel.payment.addListener(_onPaymentURL);
  }

  @override
  void dispose() {
    widget.viewModel.payment.removeListener(_onPaymentURL);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                if (widget.viewModel.fetchCollection.running) {
                  return Center(child: CircularProgressIndicator());
                }
                if (widget.viewModel.fetchCollection.error) {
                  final errorResult =
                      widget.viewModel.fetchCollection.result as Failure;
                  widget.viewModel.fetchCollection.clearResult();
            
                  DisplayableException dispExp = DisplayableException(
                    "Error desconocido",
                  );
            
                  // Safely check if the inner exception is a DisplayableException
                  if (errorResult.error is DisplayableException) {
                    dispExp = errorResult.error as DisplayableException;
                  } else {
                    // Print non-displayable errors to console for debug
                    debugPrint(
                      "Unhandled background error: ${errorResult.error}",
                    );
                  }
            
                  return Center(
                    child: ErrorIndicator(
                      title: dispExp.message,
                      label: 'Volver al escaner',
                      onPressed: () {
                        widget.viewModel.verifyQR.clearResult();
                        widget.viewModel.resetPayment();
                      },
                    ),
                  );
                }
            
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Detalles de la Entrega',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: widget.viewModel.getWasteName(
                        widget.viewModel.collection.idWasteType,
                      ),
            
                      decoration: const InputDecoration(
                        labelText: 'Material',
                        prefixIcon: Icon(Icons.table_chart),
                      ),
                      keyboardType: TextInputType.number,
                      enabled: false,
                    ),
            
                    const SizedBox(height: 15),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Masa (gramos)',
                        prefixIcon: Icon(Icons.scale),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: widget.viewModel.updateMass,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Precio por Kilogramo (MXN/Kg)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: widget.viewModel.updatePrice,
                    ),
                    const Divider(height: 40),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pago al recolector (80%)',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${widget.viewModel.paymentCollector.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Comsión Diakron (20%)',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${widget.viewModel.paymentDiakron.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total a pagar',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '\$${widget.viewModel.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
            
                    const SizedBox(height: 25),
            
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        // Cambia sutilmente el fondo si está seleccionado para dar feedback visual
                        color: widget.viewModel.isCash
                            ? Colors.amber.shade50.withValues(alpha: 0.4)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: BoxBorder.all(
                          color: widget.viewModel.isCash
                              ? Colors.amber.shade300
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        // Icono condicional a la izquierda
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.viewModel.isCash
                                ? Colors.amber.shade100
                                : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.payments_outlined,
                            color: widget.viewModel.isCash
                                ? Colors.amber.shade800
                                : Colors.grey.shade600,
                          ),
                        ),
                        title: const Text(
                          "¿Pago al recolector en efectivo?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          widget.viewModel.isCash
                              ? "Solo se pagará el 20% de comisión vía App"
                              : 'Se pagará al recolector y la comisión en un solo movimiento',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        value: widget.viewModel.isCash,
                        // Colores del Switch ajustados a la marca Diakron (Verde) u oro constructivo
                        activeThumbColor: const Color(0xFF38761D),
                        activeTrackColor: const Color(
                          0xFF38761D,
                        ).withValues(alpha: 0.2),
                        // Eliminamos el setState redundante
                        onChanged: (val) => widget.viewModel.toggleIsCash(),
                      ),
                    ),
            
                    const SizedBox(height: 25),
            
                    FormButton(
                      text: widget.viewModel.isCash
                          ? 'Pagar Comisión (20%)'
                          : 'Pagar con Mercado Pago',
                      onPressed: widget.viewModel.canPay
                          ? widget.viewModel.payment.execute
                          : null,
                      listenable: widget.viewModel.payment,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl() async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(widget.viewModel.checkoutURL),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: theme.colorScheme.surface,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }

  void _onPaymentURL() async {
    if (widget.viewModel.payment.completed) {
      widget.viewModel.payment.clearResult();
      _launchUrl();
    }
    if (widget.viewModel.payment.error) {
      final error = widget.viewModel.payment.result;
      widget.viewModel.payment.clearResult();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
            persist: false,
            dismissDirection: DismissDirection.horizontal,
            content: Text('Error: $error'),
            action: SnackBarAction(
              label: "Try again",
              onPressed: () => widget.viewModel.payment.execute(),
            ),
          ),
        );
      }
    }
  }
}
