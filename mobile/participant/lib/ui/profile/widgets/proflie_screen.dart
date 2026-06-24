import 'package:diakron_participant/routing/routes.dart';
import 'package:diakron_participant/ui/core/themes/colors.dart';
import 'package:diakron_participant/ui/core/ui/custom_alert_dialog.dart';
import 'package:diakron_participant/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_participant/ui/core/ui/error_indicator.dart';
import 'package:diakron_participant/ui/profile/view_models/profile_viewmodel.dart';
import 'package:diakron_participant/ui/profile/widgets/editable_info_tile.dart';
import 'package:diakron_participant/utils/displayable_exception.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.viewModel});

  final ProfileViewmodel viewModel;

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
      backgroundColor: const Color(0xFFF5F7FA),

      body: ListenableBuilder(
        listenable: widget.viewModel.load,

        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.load.error ||
              widget.viewModel.participant == null) {
            return Center(
              child: ErrorIndicator(
                title: 'Ocurrió un error al cargar tu perfil',
                label: 'Reintentar',
                onPressed: widget.viewModel.load.execute,
              ),
            );
          }

          final participant = widget.viewModel.participant!;

          final stats = widget.viewModel.userWasteStats;

          final Map<String, int> realMaterials = {
            'Metal': stats.countMetal,
            'Plástico': stats.countPlastic,
            'Papel/Cartón': stats.countPaper,
            'Vidrio': stats.countGlass,
          };

          final Map<String, String> realEnergySavings = {
            'metal': '${stats.metalEnergy.toStringAsFixed(2)} kWh',

            'paper': '${stats.paperEnergy.toStringAsFixed(2)} kWh',

            'plastic': '${stats.plasticEnergy.toStringAsFixed(2)} kWh',

            'glass': '${stats.glassEnergy.toStringAsFixed(2)} kWh',
          };

          return CustomScrollView(
            slivers: [
              // HEADER
              SliverToBoxAdapter(child: _buildHeader(participant)),

              // CONTENT
              SliverPadding(
                padding: const EdgeInsets.all(20),

                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildInfoSection("Información Personal", [
                      EditableInfoTile(
                        icon: Icons.person_outline,
                        label: "Nombre",
                        value: participant.userName,
                        controller: _usernameController,
                        onSave: () {
                          if (_usernameController.text !=
                              participant.userName) {
                            widget.viewModel.updateField.execute((
                              'user_name',
                              _usernameController.text,
                            ));
                          }
                        },
                      ),
                      EditableInfoTile(
                        icon: Icons.badge,
                        label: "Apellidos",
                        value: participant.surnames,
                        controller: _surnamesController,
                        onSave: () {
                          if (_surnamesController.text !=
                              participant.surnames) {
                            widget.viewModel.updateField.execute((
                              'surnames',
                              _surnamesController.text,
                            ));
                          }
                        },
                      ),
                      EditableInfoTile(
                        icon: Icons.email_outlined,
                        label: "Correo electrónico",
                        value: participant.email,
                      ),

                      // Campo EDITABLE (se le pasa controlador)
                      EditableInfoTile(
                        icon: Icons.phone_android_outlined,
                        label: "Teléfono",
                        value: participant.phoneNumber,
                        controller: _phoneController,
                        onSave: () {
                          if (_phoneController.text !=
                              participant.phoneNumber) {
                            widget.viewModel.updateField.execute((
                              'phone_number',
                              _phoneController.text,
                            ));
                          }
                        },
                      ),
                      EditableInfoTile(
                        icon: Icons.confirmation_number_outlined,
                        label: "Puntos acumulados",
                        value: '${participant.points}',
                      ),
                    ]),

                    const SizedBox(height: 24),

                    _buildStatsSection(realMaterials, realEnergySavings),

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

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(participant) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 20,
        20,
        35,
      ),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.greenDiakron4, AppColors.greenDiakron1],

          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,

            child: Text(
              participant.userName[0].toUpperCase(),

              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: AppColors.greenDiakron1,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "${participant.userName} ${participant.surnames}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            participant.userType.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              letterSpacing: 1.2,
            ),
          ),
        ],
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

  Widget _buildStatsSection(
    Map<String, int> materials,
    Map<String, String> savings,
  ) {
    final Map<String, Color> materialColors = {
      'Metal': const Color(0xFF9E9E9E),
      'Plástico': const Color(0xFFFFB74D),
      'Papel/Cartón': const Color(0xFF2980B9),
      'Vidrio': const Color(0xFF33691E),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            'Tus estadísticas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.viewModel.userWasteStats.isEmpty
              ? _buildEmptyStats()
              : Column(
                  children: [
                    const Text(
                      'Material reciclado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- 1. EL GRÁFICO (Ahora mucho más grande) ---
                    SizedBox(
                      height: 220, // Aumentado para darle máxima presencia
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius:
                              60, // Centro más amplio para un look moderno de dona
                          sections: _showingSections(materials, materialColors),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // --- 2. LAS LEYENDAS ABAJO (Responsivas con Wrap) ---
                    Wrap(
                      spacing: 16, // Espacio horizontal entre leyendas
                      runSpacing:
                          10, // Espacio vertical si se crean varias filas
                      alignment:
                          WrapAlignment.center, // Centra el bloque de leyendas
                      children: materials.keys.map((name) {
                        final value = materials[name] ?? 0;
                        if (value == 0) return const SizedBox.shrink();

                        return Row(
                          mainAxisSize: MainAxisSize
                              .min, // Ocupa solo el espacio necesario
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: materialColors[name] ?? Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$name ($value)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),
                    const Divider(height: 1),
                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Ahorro energético',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEnergySavingsGrid(savings),
                    const SizedBox(height: 30),
                    Text(
                      "Estos valores representan la cantidad de energía ahorrada por haber reciclado utilizando Diakron",
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  // --- Helper del Gráfico optimizado para mayor tamaño ---
  List<PieChartSectionData> _showingSections(
    Map<String, int> materials,
    Map<String, Color> materialColors,
  ) {
    return materials.entries.map((entry) {
      final name = entry.key;
      final value = entry.value;

      if (value == 0) {
        return PieChartSectionData(value: 0, radius: 0, title: '');
      }

      return PieChartSectionData(
        color: materialColors[name] ?? Colors.grey,
        value: value.toDouble(),
        title: '$value', // El número se queda dentro luciendo limpio
        radius: 38, // Rebanadas más gruesas y visibles
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titlePositionPercentageOffset:
            0.5, // Perfectamente centrado en la rebanada
      );
    }).toList();
  }

  // --- Helper: Build the Icons + Values Grid ---
  Widget _buildEnergySavingsGrid(Map<String, String> savings) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        _buildEnergyItem(
          'assets/symbols/waste-types/ic_metal.png',
          savings['metal'] ?? '0.00 kWh',
        ),
        _buildEnergyItem(
          'assets/symbols/waste-types/ic_plastic.png',
          savings['plastic'] ?? '0.00 kWh',
        ),
        _buildEnergyItem(
          'assets/symbols/waste-types/ic_paper.png',
          savings['paper'] ?? '0.00 kWh',
        ),
        _buildEnergyItem(
          'assets/symbols/waste-types/ic_glass.png',
          savings['glass'] ?? '0.00 kWh',
        ),
      ],
    );
  }

  Widget _buildEnergyItem(String imagePath, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF212121),
            borderRadius: BorderRadius.circular(10),
          ),
          // Usamos Center para que la imagen se comporte exactamente igual que el Icon
          child: Center(
            child: Image.asset(
              imagePath,
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),

      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,

            decoration: BoxDecoration(
              color: AppColors.greenDiakron1.withOpacity(0.1),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.bar_chart_rounded,
              size: 45,
              color: AppColors.greenDiakron1,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Aún no tienes estadísticas',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Text(
            'Comienza a reciclar materiales para visualizar tu progreso y ahorro energético.',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.5,
              fontSize: 14,
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
}
