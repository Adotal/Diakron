import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_admin/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:diakron_admin/ui/profile/view_models/profile_view_model.dart';
import 'package:diakron_admin/ui/profile/widgets/editable_info_tile.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.viewModel});

  final ProfileViewModel viewModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _surnamesController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.load.execute();
    widget.viewModel.updateField.addListener(_onUpdateField);
    widget.viewModel.deleteAccount.addListener(_onDeleteAccount);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _surnamesController.dispose();
    _usernameController.dispose();
    widget.viewModel.updateField.removeListener(_onUpdateField);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      widget.viewModel.load.execute();
      oldWidget.viewModel.updateField.removeListener(_onUpdateField);
      widget.viewModel.updateField.addListener(_onUpdateField);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.load.error) {
            return Center(
              child: ErrorIndicator(
                title: 'Error cargando información',
                label: 'Recargar',
                onPressed: widget.viewModel.load.execute,
              ),
            );
          }
          final admin = widget.viewModel.admin;
          final size = MediaQuery.of(context).size;

          String memberSince = 'N/A';
          if (admin.createdAt != null) {
            memberSince = DateFormat('dd MMMM, yyyy').format(admin.createdAt!);
          }

          return Column(
            children: [
              // --- CABECERA ---
              Stack(
                children: [
                  Container(
                    height: size.height * 0.30,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xFF38761D)),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Text(
                              admin.userName != null
                                  ? admin.userName![0].toUpperCase()
                                  : 'N/A',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38761D),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${admin.userName} ${admin.surnames}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          admin.userType!.toUpperCase(),                          
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // --- LISTA DE INFORMACIÓN ---
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildInfoSection("Información Personal", [
                      // Campo NO editable (sin controlador)
                      EditableInfoTile(
                        icon: Icons.person_outline,
                        label: "Nombre",
                        value: admin.userName ?? 'N/A',
                        controller: _usernameController,
                        onSave: () {
                          if (_usernameController.text != admin.userName) {
                            widget.viewModel.updateField.execute((
                              'user_name',
                              _usernameController.text,
                            ));
                          }
                        },
                      ),
                      EditableInfoTile(
                        icon: Icons.person_outline,
                        label: "Apellidos",
                        value: admin.surnames ?? 'N/A',
                        controller: _surnamesController,
                        onSave: () {
                          if (_surnamesController.text != admin.surnames) {
                            widget.viewModel.updateField.execute((
                              'surnames',
                              _surnamesController.text,
                            ));
                          }
                        },
                      ),
                      // Campo NO editable
                      EditableInfoTile(
                        icon: Icons.email_outlined,
                        label: "Correo electrónico",
                        value: admin.email ?? 'N/A',
                      ),
                      // Campo EDITABLE (se le pasa controlador)
                      EditableInfoTile(
                        icon: Icons.phone_android_outlined,
                        label: "Teléfono",
                        value: admin.phoneNumber ?? 'N/A',
                        controller: _phoneController,
                        onSave: () {
                          if (_phoneController.text != admin.phoneNumber) {
                            widget.viewModel.updateField.execute((
                              'phone_number',
                              _phoneController.text,
                            ));
                          }
                        },
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection("Cuenta", [
                      EditableInfoTile(
                        icon: Icons.calendar_today_outlined,
                        label: "Miembro desde",
                        value: memberSince,
                      ),
                      EditableInfoTile(
                        icon: Icons.supervisor_account_outlined,
                        label: "Superadministrador",
                        value: admin.isSuperadmin! ? 'Sí' : 'No',
                      ),
                      _statusTile(admin.isActive!),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection('Seguridad', [
                      ElevatedButton(
                        onPressed: () {
                          context.push(Routes.forgotpassword);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cambiar contraseña'),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Botón de Cerrar Sesión
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: OutlinedButton.icon(
                        onPressed: widget.viewModel.logout.execute,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text("Cerrar Sesión"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          CustomAlertDialog.show(
                            context: context,
                            title: '¿Seguro de borrar tu cuenta?',
                            content: 'Esta acción es irreversible',
                            actionText: 'Eliminar',
                            actionButtonColor: Colors.red,
                            onPressed: () {
                              widget.viewModel.deleteAccount.execute();
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey.shade900,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text(
                          "Eliminar cuenta permanentemente",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _statusTile(bool isActive) {
    return ListTile(
      leading: Icon(
        isActive ? Icons.check_circle_outline : Icons.error_outline,
        color: isActive ? Colors.green : Colors.red,
      ),
      title: const Text(
        "Estado de la cuenta",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        isActive ? "Activo" : "Inactivo",
        style: TextStyle(
          fontSize: 16,
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onUpdateField() {
    if (widget.viewModel.updateField.completed) {
      widget.viewModel.updateField.clearResult();
      if (!mounted) return;
      CustomSnackBar.showSuccess(context, message: "Campo actualizado");
    }
    if (widget.viewModel.updateField.error) {
      final errorResult = widget.viewModel.updateField.result as Failure;
      widget.viewModel.updateField.clearResult();

      if (!mounted) return;
      DisplayableException dispExp = DisplayableException(
        "No se logró actualizar el campo",
      );

      // Safely check if the inner exception is a DisplayableException
      if (errorResult.error is DisplayableException) {
        dispExp = errorResult.error as DisplayableException;
      } else {
        // Print non-displayable errors to console for debug
        debugPrint("Unhandled background error: ${errorResult.error}");
      }
      CustomSnackBar.showError(context, message: dispExp.message);
    }
  }

  void _onDeleteAccount() {
    if (widget.viewModel.deleteAccount.completed) {
      widget.viewModel.deleteAccount.clearResult();
      if (!mounted) return;
      CustomSnackBar.showSuccess(context, message: "Cuenta eliminada");

      widget.viewModel.logout.execute();
    }
    if (widget.viewModel.deleteAccount.error) {
      final errorResult = widget.viewModel.deleteAccount.result as Failure;
      widget.viewModel.deleteAccount.clearResult();
      CustomSnackBar.showError(
        context,
        message: (errorResult.error as DisplayableException).message,
      );
    }
  }
}