import 'package:diakron_admin/models/core/validation_status/validation_status.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:diakron_admin/ui/core/ui/form_button.dart';
import 'package:diakron_admin/ui/users_menu/stores/table/view_models/stores_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key, required this.viewModel});

  final StoresViewModel viewModel;

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  @override
  void initState() {
    super.initState();
    // Loads only if its empty
    if (!widget.viewModel.load.running &&
        widget.viewModel.load.result == null) {
      widget.viewModel.load.execute();
    }
  }

  @override
  void didUpdateWidget(covariant StoresScreen oldWidget) {
    if (!widget.viewModel.load.running &&
        widget.viewModel.load.result == null) {
      widget.viewModel.load.execute();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder is the modern way to listen to a ChangeNotifier ViewModel
    return CustomScreen(
      actions: [
        IconButton(
          onPressed: _showStatusInfo,
          icon: const Icon(Icons.info_outline, color: Colors.white),
        ),
      ],
      title: 'Tiendas asociadas',

      // floatingActionButton:
      // FloatingActionButton(
      //   onPressed: () {
      //     ScaffoldMessenger.of(
      //       context,
      //     ).showSnackBar(const SnackBar(content: Text('FAB tapped!')));
      //   },
      //   shape: CircleBorder(),
      //   foregroundColor: Colors.white,
      //   backgroundColor: Colors.blueGrey,
      //   child: const Icon(Icons.add),
      // ),
      child: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.load.error) {
            return Center(
              child: ErrorIndicator(
                title: 'Error al cargar tiendas',
                label: 'Intentar de nuevo',
                onPressed: widget.viewModel.load.execute,
              ),
            );
          }

          return child!;
        },
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return RefreshIndicator(
              onRefresh: () => widget.viewModel.load.execute(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SearchBar(
                      hintText: 'Buscar tienda...',
                      leading: const Icon(Icons.search),
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.white,
                      ),
                      onChanged: widget.viewModel.updateSearchQuery,
                      trailing: [
                        //   IconButton(
                        //     icon: const Icon(Icons.sort),
                        //     onPressed: () => _showFilterSheet(context),
                        //   ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      // Se ajustó el padding para la lista completa
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      itemCount: widget.viewModel.stores.length,
                      itemBuilder: (context, index) {
                        final center = widget.viewModel.stores[index];

                        // Se reemplazó Card por un Container blanco limpio con bordes
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: BoxBorder.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {                                
                                context.push(Routes.storeById(center.id!), extra: widget.viewModel.totalPoints);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.business,
                                      color: Colors.blueGrey.shade700,
                                    ),
                                  ),
                                  title: Text(
                                    center.commercialName ?? 'No Name',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Puntos canjeados: ${center.pointsExchanged}\n'
                                    'Representación: ${(center.pointsExchanged * 100 / widget.viewModel.totalPoints).toStringAsFixed(2)} %',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),

                                    // Text(
                                    //   'RFC: ${center.rfc ?? "N/A"}',
                                    //   style: TextStyle(
                                    //     color: Colors.grey.shade600,
                                    //     fontSize: 13,
                                    //   ),
                                  ),
                                  trailing: _buildStatusIcon(
                                    center.validationStatus,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Extraje los íconos de estado a un método para mantener el código principal más limpio
  Widget _buildStatusIcon(String? status) {
    switch (status) {
      case ValidationStatus.uploading:
        return const Icon(Icons.cloud_upload_outlined, color: Colors.blueGrey);
      case ValidationStatus.pending:
        return const Icon(Icons.pending_actions, color: Colors.amber);
      case ValidationStatus.denied:
        return const Icon(Icons.cancel, color: Colors.red);
      case ValidationStatus.approved:
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }

  void _showStatusInfo() {
    CustomAlertDialog.show(
      actionText: 'Ok',
      onPressed: () {},
      title: 'Tipos de estado',
      context: context,
      content: '',
      children: [
        ListTile(
          leading: Icon(Icons.pending_actions, color: Colors.amber),
          title: Text('VALIDACIÓN PENDIENTE'),
        ),
        ListTile(
          leading: Icon(Icons.cloud_upload_outlined, color: Colors.blueGrey),
          title: Text('SUBIENDO ARCHIVOS'),
        ),
        ListTile(
          leading: Icon(Icons.cancel, color: Colors.red),
          title: Text('RECHAZADO'),
        ),
        ListTile(
          leading: Icon(Icons.check_circle, color: Colors.greenAccent),
          title: Text('APROBADO'),
        ),
      ],
    );
  }
}
