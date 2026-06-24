import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_stores/ui/core/ui/custom_network_image.dart';
import 'package:diakron_stores/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_stores/ui/core/ui/error_indicator.dart';
import 'package:diakron_stores/ui/profile/view_models/profile_viewmodel.dart';
import 'package:diakron_stores/ui/profile/widgets/editable_info_tile.dart';
import 'package:diakron_stores/utils/displayable_exception.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.viewModel,
    this.showSuccessMp = false,
  });

  final ProfileViewmodel viewModel;

  final bool showSuccessMp;

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

    // Si la app estaba cerrada y se abrió directamente con el deep link
    if (widget.showSuccessMp) {
      _triggerSuccessFlow();
    }
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

    // Si la bandera 'refresh' cambió de false a true, ejecutamos el comando
    if (widget.showSuccessMp) {
      _triggerSuccessFlow();
    }
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
          final store = widget.viewModel.store;
          final size = MediaQuery.of(context).size;

          String memberSince = 'N/A';
          if (store.createdAt != null) {
            memberSince = DateFormat('dd MMMM, yyyy').format(store.createdAt!);
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
                              store.userName != null
                                  ? store.userName![0].toUpperCase()
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
                          "${store.userName} ${store.surnames}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          store.userType!.toUpperCase(),
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
                    // Mercado Pago Button/State
                    Container(
                      decoration: BoxDecoration(
                        // Si está vinculado, usamos un color verde de éxito; si no, el azul de MP
                        color: const Color(0xFF009EE3),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF009EE3,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          // Si ya está vinculado, pasamos 'null' a onTap para deshabilitar el botón
                          onTap: widget.viewModel.isMpLinked
                              ? null
                              : () {
                                  // String backendUrl =
                                  //     'https://diakron-backend.onrender.com';
                                  String backendUrl =
                                      'https://diakron-backend.onrender.com';

                                  // State must be USER_TYPE:ID
                                  String state =
                                      '${store.userType}:${store.id}';

                                  String url =
                                      'https://auth.mercadopago.com.mx/authorization?client_id=6905766354198667&response_type=code&platform_id=mp&redirect_uri=$backendUrl/oauth/callback&state=$state';
                                  debugPrint(url);
                                  _launchUrl(url, context);
                                },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Cambiamos dinámicamente el logo de MP por un check de éxito si está vinculado
                                widget.viewModel.isMpLinked
                                    ? const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 30,
                                      )
                                    : Image.asset(
                                        'assets/images/mercado_pago.png',
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),

                                const SizedBox(width: 10),

                                // Cambiamos el texto explicativo según el estado
                                Text(
                                  widget.viewModel.isMpLinked
                                      ? "Mercado Pago Vinculado"
                                      : "Vincular Mercado Pago",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInfoSection('Negocio', [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.viewModel.store.commercialName!,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                          CustomNetworkImage(
                            urlImage: widget.viewModel.store.urlLogo,
                          ),
                        ],
                      ),
                    ]),
                    SizedBox(height: 20),

                    _buildInfoSection("Información Personal", [
                      EditableInfoTile(
                        icon: Icons.person_outline,
                        label: "Nombre",
                        value: store.userName ?? 'N/A',
                        controller: _usernameController,
                        onSave: () {
                          if (_usernameController.text != store.userName) {
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
                        value: store.surnames ?? 'N/A',
                        controller: _surnamesController,
                        onSave: () {
                          if (_surnamesController.text != store.surnames) {
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
                        value: store.email ?? 'N/A',
                      ),
                      // Campo EDITABLE (se le pasa controlador)
                      EditableInfoTile(
                        icon: Icons.phone_android_outlined,
                        label: "Teléfono",
                        value: store.phoneNumber ?? 'N/A',
                        controller: _phoneController,
                        onSave: () {
                          if (_phoneController.text != store.phoneNumber) {
                            widget.viewModel.updateField.execute((
                              'phone_number',
                              _phoneController.text,
                            ));
                          }
                        },
                      ),
                    ]),

                    const SizedBox(height: 20),
                    _buildInfoSection('Información del negocio', [
                      EditableInfoTile(
                        icon: Icons.email_outlined,
                        label: "Correo de facturación",
                        value: store.billingEmail ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.apartment_outlined,
                        label: "Razón social / Nombre legal de la empresa",
                        value: store.companyName ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.domain,
                        label: "Nombre comercial (visible públicamente)",
                        value: store.commercialName ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.location_on_outlined,
                        label: "Dirección del negocio",
                        value: store.address ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.location_on_outlined,
                        label: "Dirección fiscal",
                        value: '',
                        // store.taxAddress ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.markunread_mailbox_outlined,
                        label: "Código postal de dirección fiscal",
                        value: store.postCode ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.badge_outlined,
                        label: "RFC",
                        value: store.rfc ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.account_balance_outlined,
                        label: "Régimen fiscal",
                        value: store.taxRegime ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.business_outlined,
                        label: "Tipo de contribuyente empresa",
                        value: store.taxpayerType ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.assured_workload_outlined,
                        label: "Banco de operaciones",
                        value: store.bank ?? 'N/A',
                      ),
                      EditableInfoTile(
                        icon: Icons.credit_card,
                        label: "CLABE",
                        value: store.clabe ?? 'N/A',
                      ),

                      EditableInfoTile(
                        icon: Icons.email_outlined,
                        label: "Correo de facturación",
                        value: store.billingEmail ?? 'N/A',
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection("Calendario", [
                      Padding(
                        padding: EdgeInsetsGeometry.all(10),
                        child: _buildCalendarSchedule(store.schedule ?? {}),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection("Cuenta", [
                      EditableInfoTile(
                        icon: Icons.calendar_today_outlined,
                        label: "Miembro desde",
                        value: memberSince,
                      ),
                      _statusTile(store.isActive!),
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

                    const SizedBox(height: 30),
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

  Widget _buildCalendarSchedule(Map<String, dynamic> schedule) {
    return Column(
      children: schedule.entries.map((entry) {
        final String day = entry.key;
        final bool isOpen = entry.value['isOpen'];
        final String hours = isOpen
            ? "${entry.value['open']} - ${entry.value['close']}"
            : "Cerrado";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: isOpen ? FontWeight.w600 : FontWeight.normal,
                    color: isOpen ? Colors.black87 : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? Colors.green.withValues(alpha: 0.05)
                        : Colors.red.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    hours,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isOpen ? Colors.green[700] : Colors.red[700],
                      fontWeight: isOpen ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem({required String dataType, required String data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$dataType:',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 20),
          Text(
            data,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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

  void _launchUrl(String url, BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(url),
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

  // Cuando deep link mercado pago success
  void _triggerSuccessFlow() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Success de snackbar
      CustomSnackBar.showSuccess(
        context,
        message: '¡Mercado Pago vinculado con éxito!',
      );

      // Al estar en el árbol de widgets correcto, context.read funcionará sin problemas
      await context.read<StoreRepository>().getStore(forceRefresh: true);

      // Volver a disparar el comando para que refresque el ViewModel con los datos del repositorio
      widget.viewModel.load.execute();
    });
  }
}
