import 'package:diakron_collection_center/models/waste_collection/waste_collection.dart';
import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/ui/collections/view_models/collections_view_model.dart';
import 'package:diakron_collection_center/ui/core/ui/custom_screen.dart';
import 'package:diakron_collection_center/ui/core/ui/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Necesario para DateFormat y NumberFormat

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key, required this.viewModel});

  final CollectionsViewModel viewModel;

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Recolecciones',
      // Eliminamos el SingleChildScrollView, ahora solo usamos Padding y Column
      child: RefreshIndicator(
        onRefresh: widget.viewModel.load.execute,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) {
                    final vm = widget.viewModel;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- SECCIÓN DE FILTROS ---
                        Text(
                          'Filtrar por',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        // const SizedBox(height: 16),
                        SizedBox(height: 10),
                        // Chips responsivos en lugar de SegmentedButton
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip(
                                'Ninguno',
                                CollectionFilterType.none,
                                vm,
                              ),
                              SizedBox(width: 12),
                              _buildFilterChip(
                                'Vidrio',
                                CollectionFilterType.glass,
                                vm,
                              ),
                              SizedBox(width: 12),
                              _buildFilterChip(
                                'Metal',
                                CollectionFilterType.metal,
                                vm,
                              ),
                              SizedBox(width: 12),
                              _buildFilterChip(
                                'Papel/Cartón',
                                CollectionFilterType.paper,
                                vm,
                              ),
                              SizedBox(width: 12),
                              _buildFilterChip(
                                'Plástico',
                                CollectionFilterType.plastic,
                                vm,
                              ),
                              SizedBox(width: 12),
                              _buildFilterChip(
                                'Fecha',
                                CollectionFilterType.date,
                                vm,
                              ),
                            ],
                          ),
                        ),
                        //  Animación suave al cambiar entre filtros
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: vm.currentFilter == CollectionFilterType.none
                                  ? 0
                                  : 24.0,
                            ),
                            child: _buildFilterContent(vm, context),
                          ),
                        ),

                        const Divider(height: 32),
                      ],
                    );
                  },
                ),
              ),

              // Lista de incentivos (Hará scroll de forma independiente)
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  if (widget.viewModel.load.running) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (widget.viewModel.load.error) {
                    return Center(
                      child: ErrorIndicator(
                        title: 'Error loading Coupons',
                        label: 'Try again',
                        onPressed: widget.viewModel.load.execute,
                      ),
                    );
                  }

                  return Expanded(
                    child: widget.viewModel.collections.isEmpty
                        ? const Center(
                            child: Text(
                              "No se encontraron resultados.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            itemCount: widget.viewModel.collections.length,
                            itemBuilder: (context, index) {
                              final collection =
                                  widget.viewModel.collections[index];

                              // BUSCAMOS EL TIPO EN LA LISTA DEL VIEWMODEL
                              final wasteTypeMap = widget
                                  .viewModel
                                  .allWasteTypes
                                  .firstWhere(
                                    (type) =>
                                        type['id'] == collection.idWasteType,
                                    orElse: () => {
                                      'id': 0,
                                      'waste_type': 'DESCONOCIDO',
                                    },
                                  );

                              return WasteCollectionCard(
                                collection: collection,
                                wasteType:
                                    wasteTypeMap, // Pasamos el Map encontrado
                                onShowQR: () {
                                  // Lógica para abrir el QR
                                  //   if (collection.isExpired() ||
                                  //       collection.isComplete) {
                                  //     ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(
                                  //         content: Text(
                                  //           collection.isExpired()
                                  //               ? 'Esta recolección ha caducado'
                                  //               : 'Esta recolección ya ha sido completada',
                                  //         ),
                                  //       ),
                                  //     );
                                  //   } else {
                                  //     // context.push(
                                  //     //   Routes.collectionQRById(
                                  //     //     '${collection.id}',
                                  //     //   ),
                                  //     // );
                                  //   }
                                },
                              );
                            },
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enruta a la vista correspondiente según el filtro
  Widget _buildFilterContent(CollectionsViewModel vm, BuildContext context) {
    switch (vm.currentFilter) {
      case CollectionFilterType.date:
        return _buildDateSelector(vm, context);
      case CollectionFilterType.none:
      default:
        return const SizedBox.shrink(); // No muestra nada
    }
  }

  Widget _buildFilterChip(
    String label,
    CollectionFilterType type,
    CollectionsViewModel vm,
  ) {
    final isSelected = vm.currentFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.green.withValues(alpha: 0.2),
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green.shade800 : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        vm.updateFilterType(type);
      },
    );
  }

  Widget _buildDateSelector(CollectionsViewModel vm, BuildContext context) {
    final hasDate = vm.dateRange != null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          if (hasDate)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.redAccent),
              onPressed: () {
                vm.updateDateRange(
                  null,
                ); // Enviamos null para limpiar el filtro
              },
            )
          else
            const Icon(Icons.calendar_month, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasDate
                  ? '${DateFormat('dd/MMM/yy').format(vm.dateRange!.start)}  →  ${DateFormat('dd/MMM/yy').format(vm.dateRange!.end)}'
                  : 'Filtrar por fecha',
              style: TextStyle(
                color: hasDate ? Colors.black87 : Colors.black54,
                fontWeight: hasDate ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),

          // Botón para borrar el filtro (Solo visible si hasDate es true)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
            ),
            onPressed: () async {
              final selectedRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                initialDateRange: vm.dateRange,
                builder: (context, child) {
                  // Inyecta el tema verde al DatePicker
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (selectedRange != null) {
                vm.updateDateRange(selectedRange);
              }
            },
            child: Text(hasDate ? 'Cambiar' : 'Elegir'),
          ),
        ],
      ),
    );
  }
}

class WasteCollectionCard extends StatelessWidget {
  final WasteCollection collection;
  final Map<String, dynamic>? wasteType; // El objeto de la lista allWasteTypes
  final VoidCallback onShowQR;

  const WasteCollectionCard({
    super.key,
    required this.collection,
    required this.wasteType,
    required this.onShowQR,
  });

  @override
  Widget build(BuildContext context) {
    // Extraemos el nombre o usamos un default si el Map es nulo
    final String typeName = wasteType?['waste_type'] ?? 'DESCONOCIDO';

    // Obtenemos estilo visual basado en el nombre (String) que viene de la BD
    final iconData = _getVisualsByTypeName(typeName);

    return InkWell(
      onTap: () => context.push(Routes.collectionDetails, extra: collection),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildTypeIcon(iconData),
                  const SizedBox(width: 16),
                  _buildInfoColumn(typeName),
                ],
              ),
            ),

            // Botón PDF estilizado
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onShowQR,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Colors.indigo,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: collection.isComplete
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  collection.isComplete
                      ? "COMPLETO"
                      : true
                      // collection.isExpired()
                      ? "CADUCADA"
                      : "PENDIENTE",
                  style: TextStyle(
                    color: collection.isComplete
                        ? Colors.green[800]
                        : Colors.orange[800],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para el icono redondo
  Widget _buildTypeIcon(_VisualData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha:  0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(data.icon, color: data.color, size: 32),
    );
  }

  // Widget auxiliar para los textos
  Widget _buildInfoColumn(String typeName) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            typeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 4),
          Text(
            "Segregador: #${collection.idSegregator}",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          Text(
            DateFormat('dd MMM, yyyy • HH:mm').format(collection.collDate.toLocal()),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Mapeo de lógica visual basada en el nombre exacto de tu lista del viewModel
  _VisualData _getVisualsByTypeName(String name) {
    switch (name.toUpperCase()) {
      case 'PLÁSTICO':
        return _VisualData(Icons.opacity, Colors.blue);
      case 'METAL':
        return _VisualData(Icons.settings_suggest, Colors.orange);
      case 'PAPEL/CARTÓN':
        return _VisualData(Icons.inventory_2, Colors.brown);
      case 'VIDRIO':
        return _VisualData(Icons.local_bar, Colors.teal);
      default:
        return _VisualData(Icons.help_outline, Colors.blueGrey);
    }
  }
}

class _VisualData {
  final IconData icon;
  final Color color;
  _VisualData(this.icon, this.color);
}
