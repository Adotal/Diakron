import 'package:diakron_collection_center/ui/core/ui/custom_screen.dart';
import 'package:diakron_collection_center/ui/stats/view_models/stats_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key, required this.viewModel});

  final StatsViewModel viewModel;

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Helper para traducir el ID al nombre del material
  String _getWasteName(int id) {
    switch (id) {
      case 1:
        return 'Plástico';
      case 2:
        return 'Metal';
      case 3:
        return 'Vidrio';
      case 4:
        return 'Papel/Cartón';
      default:
        return 'Otros';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Progreso',
      child: ListenableBuilder(
        listenable: widget.viewModel.load,
        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = widget.viewModel.collectionWeights;
          final Map<String, double> realMaterials = {};

          for (var item in stats) {
            final wasteId = item['waste_type'] as int;
            final totalMass = (item['total_mass'] as num).toDouble();
            final materialName = _getWasteName(wasteId);
            realMaterials[materialName] = totalMass;
          }
          return Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
              left: 24.0,
              right: 24.0,
              bottom: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [                
                const Text(
                  'Cantidad de materiales recibidos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),

                // 3. Este Expanded toma TODO el espacio vertical restante de la pantalla
                Expanded(
                  child: Center(
                    // Centra su contenido perfectamente en ese espacio restante
                    child: stats.isEmpty
                        ? const Text(
                            "No hay información de materiales entregados\n ¡Pero puedes empezar ahora!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          )
                        : SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 0,
                                startDegreeOffset: 270,
                                sections: _showingSections(realMaterials),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper: Define Chart Colors & Layout ---
  List<PieChartSectionData> _showingSections(Map<String, double> materials) {
    final Map<String, Color> materialColors = {
      'Metal': const Color(0xFF9E9E9E),
      'Plástico': const Color(0xFFFFB74D),
      'Papel/Cartón': const Color(0xFF2980B9),
      'Vidrio': const Color(0xFF33691E),
      'Otros': Colors.black,
    };

    return materials.entries.map((entry) {
      final name = entry.key;
      final valueGrams = entry.value;

      if (valueGrams <= 0) {
        return PieChartSectionData(value: 0, radius: 0, title: '');
      }

      // Convertimos a kilos para que la etiqueta se vea mejor (ej. 6.5 kg)
      final kgValue = (valueGrams / 1000).toStringAsFixed(3);

      const double radius = 100;
      const labelStyle = TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

      return PieChartSectionData(
        color: materialColors[name] ?? Colors.grey,
        value:
            valueGrams, // fl_chart usa esto para calcular la proporción de la rebanada
        title:
            '$name\n$kgValue kg', // Y usa esto para el texto que lee el usuario
        radius: radius,
        titleStyle: labelStyle,
        titlePositionPercentageOffset: 1.3,
        badgeWidget: null,
      );
    }).toList();
  }
}
