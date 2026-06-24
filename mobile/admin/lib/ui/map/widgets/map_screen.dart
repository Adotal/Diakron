import 'dart:typed_data';

import 'package:diakron_admin/models/segregator/segregator.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/ui/custom_map_header.dart';
import 'package:diakron_admin/ui/map/view_models/map_viewmodel.dart';
import 'package:diakron_admin/ui/map/widgets/location_card.dart';
import 'package:diakron_admin/ui/map/widgets/map_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.viewModel});
  final MapViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointManager;
  // Diccionario para vincular el ID del marcador en el mapa con los datos del Segregador
  final Map<String, Segregator> _markerMap = {};

  CameraOptions camera = CameraOptions(
    center: Point(
      coordinates: Position(-103.348821, 20.671956), // Guadalajara
    ),
    zoom: 13,
    bearing: 0,
    pitch: 0,
  );

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    // For markers creation as Annotations
    pointManager = await mapboxMap.annotations.createPointAnnotationManager();

    _loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _loadMarkers();
        });

        return Scaffold(
          // El fondo de la pantalla es verde
          backgroundColor: AppColors.greenDiakron1,
          floatingActionButton: widget.viewModel.isMapSelected
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 4,
                  tooltip: 'Ver Leyenda',
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () => _showLegendDialog(context),
                  child: Icon(
                    Icons.info_outline,
                    color: AppColors.greenDiakron1,
                    size: 30,
                  ),
                )
              : null,
          body: Column(
            children: [
              CustomMapHeader(
                title: widget.viewModel.showSegregadores
                    ? "Segregadores"
                    : "Centros de Acopio",
                onSearch: (text) => widget.viewModel.updateSearchText(text),
                userAvatar: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              // White card
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundDiakron,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    // The map retains its rounded corners
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: MapControls(
                            isMapSelected: widget.viewModel.isMapSelected,
                            showSegregadores: widget.viewModel.showSegregadores,
                            onToggleViewMode: () =>
                                widget.viewModel.toggleViewMode(),
                            onToggleLocationType: () =>
                                widget.viewModel.toggleLocationType(),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: widget.viewModel.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : widget.viewModel.isMapSelected
                                ? _buildMapViewWidget()
                                : _buildLocationListView(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // WIDGET: Map
  Widget _buildMapViewWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MapWidget(cameraOptions: camera, onMapCreated: _onMapCreated),
      ),
    );
  }

  // WIDGET: list
  Widget _buildLocationListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: widget.viewModel.segregators.length,
      itemBuilder: (context, index) {
        final segregator = widget.viewModel.segregators[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: LocationCard(
            description: segregator.description!,
            bin: segregator.bins,
            isConnected: segregator.isActive,
            // avatarUrl: segregator.avatarUrl,
            onTap: () => _showSegregatorDetails(segregator),
          ),
        );
      },
    );
  }

  Future<void> _loadMarkers() async {
    if (pointManager == null) return;

    // Clear previous values
    await pointManager!.deleteAll();
    _markerMap.clear();

    pointManager!.tapEvents(
      onTap: (annotation) {
        final segregator = _markerMap[annotation.id];
        if (segregator != null) {
          _showSegregatorDetails(segregator);
        }
        return true; // Retornamos true para indicar que manejamos el clic
      },
    );

    final locations = widget.viewModel.segregators;
    if (locations.isEmpty) return;

    // 1. Load all 5 color variations from assets
    final Uint8List imgGreen = (await rootBundle.load(
      'assets/symbols/recycling_green.png',
    )).buffer.asUint8List();
    final Uint8List imgYellow = (await rootBundle.load(
      'assets/symbols/recycling_yellow.png',
    )).buffer.asUint8List();
    final Uint8List imgOrange = (await rootBundle.load(
      'assets/symbols/recycling_orange.png',
    )).buffer.asUint8List();
    final Uint8List imgRed = (await rootBundle.load(
      'assets/symbols/recycling_red.png',
    )).buffer.asUint8List();
    final Uint8List imgGray = (await rootBundle.load(
      'assets/symbols/recycling_gray.png',
    )).buffer.asUint8List();

    for (var loc in locations) {
      if (loc.latitude == null || loc.longitude == null) continue;
      final point = Point(coordinates: Position(loc.longitude!, loc.latitude!));

      Uint8List selectedImage;
      // Determine which image to use
      if (!loc.isActive) {
        selectedImage = imgGray;
      } else {
        // Count how many bins are above 80%
        // Note: Make sure 'fillingPercentage' matches your BinModel property name
        int criticalBinsCount = loc.bins
            .where((bin) => (bin.fillingPercentage > 80))
            .length;

        if (criticalBinsCount == 0) {
          selectedImage = imgGreen;
        } else if (criticalBinsCount == 1) {
          selectedImage = imgYellow;
        } else if (criticalBinsCount == 2) {
          selectedImage = imgOrange;
        } else {
          selectedImage = imgRed; // 3 or more bins mo
        }
      }

      //Create the annotation
      final annotation = await pointManager!.create(
        PointAnnotationOptions(
          geometry: point,
          image: selectedImage,
          iconSize: 0.1,
        ),
      );
      // Guardamos la relación: ID del Pin -> Datos del Segregador
      _markerMap[annotation.id] = loc;
    }
  }

  void _showSegregatorDetails(Segregator loc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado
              Row(
                children: [
                  Icon(
                    loc.isActive ? Icons.check_circle : Icons.error,
                    color: loc.isActive ? AppColors.greenDiakron1 : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.isActive ? 'Operativo' : 'Sin conexión',
                    style: TextStyle(
                      color: loc.isActive
                          ? AppColors.greenDiakron1
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Nombre/Descripción
              Text(
                loc.description ?? 'Punto de recolección',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Niveles de llenado
              const Text(
                'Niveles de llenado:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: loc.bins
                    .map(
                      (b) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          '${b.fillingPercentage}% ${b.wasteType}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 30), // Niveles de llenado

              Text(
                'Última recolección: ${loc.lastCollection != null ? DateFormat('dd/MM/yyyy HH:mm').format(loc.lastCollection!.toLocal()) : 'N/A'}',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Función principal para mostrar el diálogo
  void _showLegendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Leyenda del Mapa',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            // Por si la pantalla es muy pequeña
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Para que el diálogo no ocupe toda la pantalla
              children: [
                _buildLegendItem(
                  'assets/symbols/recycling_green.png',
                  '0 botes > 80% (Normal)',
                ),
                const SizedBox(height: 15),
                _buildLegendItem(
                  'assets/symbols/recycling_yellow.png',
                  '1 bote > 80% (Atención)',
                ),
                const SizedBox(height: 15),
                _buildLegendItem(
                  'assets/symbols/recycling_orange.png',
                  '2 botes > 80% (Crítico)',
                ),
                const SizedBox(height: 15),
                _buildLegendItem(
                  'assets/symbols/recycling_red.png',
                  '3+ botes > 80% (Muy Crítico)',
                ),
                const SizedBox(height: 15),
                _buildLegendItem(
                  'assets/symbols/recycling_gray.png',
                  'Inactivo / Sin conexión',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cierra el diálogo
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Widget auxiliar para crear cada fila de la leyenda (Imagen + Texto)
  Widget _buildLegendItem(String imagePath, String description) {
    return Row(
      children: [
        // Asegúrate de que las imágenes existan en tu pubspec.yaml
        Image.asset(
          imagePath,
          width: 35, // Ajusta el tamaño de la imagen en la leyenda
          height: 35,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(description, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
