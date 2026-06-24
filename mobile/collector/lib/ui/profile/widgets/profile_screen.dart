import 'package:diakron_collectors/ui/core/ui/error_indicator.dart';
import 'package:diakron_collectors/ui/profile/view_models/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.viewModel,
    this.refresh = false,
  });

  final ProfileViewModel viewModel;
  final bool refresh;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load.execute();
  }

  // <-- 3. ESTA ES LA MAGIA: Captura el cambio de ruta instantáneamente
  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la bandera 'refresh' cambió de false a true, ejecutamos el comando
    if (widget.refresh && !oldWidget.refresh) {
      widget.viewModel.load.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, _) {
          if (widget.viewModel.load.running) {
            return Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.load.error) {
            return ErrorIndicator(
              title: 'Error cargando información',
              label: 'Recargar',
              onPressed: widget.viewModel.load.execute,
            );
          }
          final collector = widget.viewModel.collector;
          final size = MediaQuery.of(context).size;

          // Formateador de fecha: "15 de mayo, 2026"
          final String memberSince = DateFormat(
            'dd MMMM, yyyy',
          ).format(collector.createdAt);
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
                              collector.userName[0].toUpperCase(),
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
                          "${collector.userName} ${collector.surnames}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          collector.userType.toUpperCase(),
                          style: TextStyle(
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
                                  String backendUrl =
                                      'https://diakron-backend.onrender.com';

                                  // State must be USER_TYPE:ID
                                  String state =
                                      '${collector.userType}:${collector.id}';

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
                    _buildInfoSection("Información Personal", [
                      _infoTile(
                        Icons.email_outlined,
                        "Correo electrónico",
                        collector.email,
                      ),
                      _infoTile(
                        Icons.phone_android_outlined,
                        "Teléfono",
                        collector.phoneNumber,
                      ),
                    ]),
                    const SizedBox(height: 20),
                    _buildInfoSection("Cuenta", [
                      _infoTile(
                        Icons.calendar_today_outlined,
                        "Miembro desde",
                        memberSince,
                      ),
                      _statusTile(collector.isActive),
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
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Contenedor blanco para agrupar ítems
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

  // Ítem individual de información
  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF38761D)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Ítem especial para el estado (Activo/Inactivo)
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
}
