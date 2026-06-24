import 'package:diakron_admin/models/core/validation_status/validation_status.dart';
import 'package:diakron_admin/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:diakron_admin/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:diakron_admin/ui/users_menu/collectors/details/view_models/collector_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CollectorDetailsScreen extends StatefulWidget {
  const CollectorDetailsScreen({super.key, required this.viewModel});

  final CollectorDetailsViewModel viewModel;

  @override
  State<CollectorDetailsScreen> createState() => _CollectorDetailsScreenState();
}

class _CollectorDetailsScreenState extends State<CollectorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.deleteCollector.addListener(_onDelete);
    widget.viewModel.updateCollector.addListener(_onUpdate);
    widget.viewModel.changeValidationStatus.addListener(_onChangedValidation);
  }

  @override
  void didUpdateWidget(covariant CollectorDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.deleteCollector.removeListener(_onDelete);
    widget.viewModel.deleteCollector.addListener(_onDelete);

    oldWidget.viewModel.updateCollector.removeListener(_onUpdate);
    widget.viewModel.updateCollector.addListener(_onUpdate);

    oldWidget.viewModel.changeValidationStatus.removeListener(
      _onChangedValidation,
    );
    widget.viewModel.changeValidationStatus.addListener(_onChangedValidation);
  }

  @override
  void dispose() {
    widget.viewModel.deleteCollector.removeListener(_onDelete);
    widget.viewModel.updateCollector.removeListener(_onUpdate);
    widget.viewModel.changeValidationStatus.removeListener(
      _onChangedValidation,
    );
    // DISPOSE ALL CONTROLLERS
    _usernameController.dispose();
    _surnamesController.dispose();
    _phoneNumberController.dispose();
    _companyNameController.dispose();
    _rfcController.dispose();
    _taxRegimeController.dispose();
    _clabeController.dispose();
    _bankController.dispose();
    _commercialNameController.dispose();
    _addressController.dispose();
    _billingEmailController.dispose();
    _postCodeController.dispose();
    super.dispose();
  }

  // UserBase Text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _createdAtController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _taxRegimeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _clabeController = TextEditingController();
  final TextEditingController _commercialNameController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _billingEmailController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();

  bool? _isActive;

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Recolectores',
      actions: [
        // Edit Toggle
        IconButton(
          icon: Icon(
            widget.viewModel.isEditing
                ? Icons.cancel_outlined
                : Icons.edit_note,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              // Start editing -> Initialize controllers
              if (!widget.viewModel.isEditing) {
                final collector = widget.viewModel.collector;
                if (collector != null) {
                  _usernameController.text = collector.userName ?? '';
                  _surnamesController.text = collector.surnames ?? '';
                  _phoneNumberController.text = collector.phoneNumber ?? '';
                  _createdAtController.text = collector.createdAt.toString();
                  _isActive = collector.isActive;

                  widget.viewModel.toggleEdit();
                }
              } else {
                CustomAlertDialog.show(
                  context: context,
                  title: 'Salir del modo edición',
                  content:
                      '¿Estás seguro de salir del modo edición?\nSe perderán los cambios no guardados',
                  onPressed: () {
                    setState(() {
                      widget.viewModel.toggleEdit();
                    });
                  },
                  actionText: 'Salir',
                );
              }
            });
          },
        ),
        // Delete remains separate
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
          onPressed: () {
            if (widget.viewModel.collector?.id != null) {
              _showDeleteConfirm(widget.viewModel.collector!.id!);
            }
          },
        ),
      ],
      // ),
      child: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel.load,
              builder: (context, _) {
                if (widget.viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (widget.viewModel.load.error) {
                  return ErrorIndicator(
                    title: "Error cargando collectore",
                    label: "Try again",
                    onPressed: widget.viewModel.load.execute,
                  );
                }

                final collector = widget.viewModel.collector;

                if (collector == null) {
                  return Center(
                    child: Text(
                      "No se encontró el centro \n ${widget.viewModel.collectorId}",
                    ),
                  );
                }

                return Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      children: [
                        const SizedBox(height: 24),
                        _buildSection("Información de usuario"),

                        _buildDataRow(
                          "Correo electrónico",
                          collector.email ?? '',
                          Icons.person_outline,
                          // controller: ,
                        ),

                        _buildDataRow(
                          "Nombre",
                          collector.userName ?? '',
                          Icons.person_outline,
                          controller: _usernameController,
                        ),
                        _buildDataRow(
                          "Apellidos",
                          collector.surnames ?? '',
                          Icons.person_outline,

                          controller: _surnamesController,
                        ),
                        _buildDataRow(
                          "Número telefónico",
                          collector.phoneNumber ?? '',
                          Icons.person_outline,

                          controller: _phoneNumberController,
                        ),

                        ListenableBuilder(
                          listenable: widget.viewModel,
                          builder: (context, _) {
                            if (widget.viewModel.collector!.isActive!) {
                              return ListTile(
                                title: Text('Activo'),
                                leading: Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                ),
                              );
                            }
                            return ListTile(
                              title: Text('Inactivo'),
                              leading: Icon(Icons.circle, color: Colors.red),
                            );
                          },
                        ),

                        _buildDataRow(
                          "Creado en",
                          collector.createdAt != null
                              ? DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(collector.createdAt!.toLocal())
                              : 'N/A',
                          Icons.person_outline,
                          controller: _createdAtController,
                        ),

                        // COMPANY DATA
                        const SizedBox(height: 24),
                      ],
                    ),

                    // Smooth Bottom Update Button and validate/deny
                    ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, _) {
                        if (widget.viewModel.updateCollector.running) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (widget.viewModel.isEditing) {
                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.green[600],
                              onPressed: () {
                                _showUpdateConfirm();
                              },
                              label: const Text(
                                "GUARDAR CAMBIOS",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        // IF NOT EDITING SHOW VALIDATE/DENY

                        return Positioned(
                          bottom: 20,
                          right: 20,
                          left: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.red,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Icon(Icons.close),
                                    SizedBox(width: 10),
                                    Text('Rechazar'),
                                  ],
                                ),
                                onPressed: () {
                                  CustomAlertDialog.show(
                                    context: context,
                                    title: 'Rechazar centro',
                                    content:
                                        '¿Seguro que quieres rechazar este centro?',
                                    actionText: 'Rechazar',
                                    actionButtonColor: Colors.red,
                                    onPressed: () {
                                      widget.viewModel.changeValidationStatus
                                          .execute(false);
                                    },
                                  );
                                },
                              ),

                              ElevatedButton(
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check),
                                    SizedBox(width: 10),
                                    Text('Validar'),
                                  ],
                                ),
                                onPressed: () {
                                  CustomAlertDialog.show(
                                    context: context,
                                    title: 'Validar collectore',
                                    content:
                                        '¿Seguro que quieres validar este collectore?',
                                    actionText: 'Validar',
                                    actionButtonColor: Colors.green,
                                    onPressed: () {
                                      widget.viewModel.changeValidationStatus
                                          .execute(true);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
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

  void _showUpdateConfirm() {
    CustomAlertDialog.show(
      context: context,
      title: 'Guardar cambios',
      content:
          '¿Seguro de guardar cambios?\nEsta acción eliminará los datos anteriores',
      actionText: 'Guardar',
      onPressed: () {
        // UPDATE EDITED Collector
        widget.viewModel.editedCollector = widget.viewModel.editedCollector
            ?.copyWith(
              isActive: _isActive!,
              phoneNumber: _phoneNumberController.text,

              surnames: _surnamesController.text,

              userName: _usernameController.text,
            );

        // EXEC UPDATE
        widget.viewModel.updateCollector.execute();
        setState(() {
          widget.viewModel.toggleEdit();
          widget.viewModel.load.execute();
        });
      },
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildDataRow(
    String label,
    String value,
    IconData icon, {
    TextEditingController? controller,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: widget.viewModel.isEditing ? 4 : 12,
      ),
      decoration: BoxDecoration(
        color: widget.viewModel.isEditing ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.viewModel.isEditing ? Colors.green : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                widget.viewModel.isEditing && controller != null
                    ? TextField(
                        enabled: widget.viewModel.isEditing,
                        controller: controller,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        // Show simply the value
                        value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatus({required String? status}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: status.statusColor.withValues(alpha: 0.1),
            child: Icon(status.statusIcon, color: status.statusColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Validación", style: TextStyle(fontSize: 12)),
              Text(
                status.statusLabel, // Uses the extension
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status.statusColor, // Uses the extension
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(String id) {
    CustomAlertDialog.show(
      context: context,
      title: 'Confirmar eliminación',
      content: '¿Estás seguro de querer borrar este usuario?',
      actionText: 'Eliminar',
      onPressed: () async {
        await widget.viewModel.deleteCollector.execute();
      },
      actionButtonColor: Colors.red,
    );
  }

  void _onUpdate() {
    if (widget.viewModel.updateCollector.completed) {
      widget.viewModel.updateCollector.clearResult();

      CustomSnackBar.showSuccess(context, message: "Recolector actualizado");
    }

    if (widget.viewModel.updateCollector.error) {
      widget.viewModel.updateCollector.clearResult();

      CustomSnackBar.showError(
        context,
        message: "Error al actualizar recolector",
      );
    }
  }

  void _onDelete() {
    if (widget.viewModel.deleteCollector.completed) {
      widget.viewModel.deleteCollector.clearResult();
      CustomSnackBar.showSuccess(context, message: "Recolector eliminado");
      context.pop();
    }

    if (widget.viewModel.deleteCollector.error) {
      widget.viewModel.deleteCollector.clearResult();

      CustomSnackBar.showError(
        context,
        message: "Error al eliminar recolector",
        onRetry: () {
          widget.viewModel.deleteCollector.execute();
        },
      );
    }
  }

  void _onChangedValidation() {
    if (widget.viewModel.changeValidationStatus.completed) {
      widget.viewModel.changeValidationStatus.clearResult();

      CustomSnackBar.showSuccess(
        context,
        message: "Cambiado estado de validación",
      );
    }

    if (widget.viewModel.changeValidationStatus.error) {
      widget.viewModel.changeValidationStatus.clearResult();

      CustomSnackBar.showSuccess(
        context,
        message: "Error cambiando estado de validación",
      );
    }
  }
}

class TimePickerTile extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const TimePickerTile({
    super.key,
    required this.label,
    this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        time?.format(context) ?? "Seleccionar",
        style: TextStyle(color: time == null ? Colors.grey : Colors.blue),
      ),
      onTap: onTap,
    );
  }
}
