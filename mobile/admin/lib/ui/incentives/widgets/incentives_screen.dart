import 'package:diakron_admin/models/incentive/incentive.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:diakron_admin/ui/core/ui/error_indicator.dart';
import 'package:diakron_admin/ui/incentives/view_models/incentives_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Necesario para DateFormat y NumberFormat

class IncentivesScreen extends StatefulWidget {
  const IncentivesScreen({super.key, required this.viewModel});

  final IncentivesViewModel viewModel;

  @override
  State<IncentivesScreen> createState() => _IncentivesScreenState();
}

class _IncentivesScreenState extends State<IncentivesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Incentivos a tiendas',
      // Eliminamos el SingleChildScrollView, ahora solo usamos Padding y Column
      child: RefreshIndicator(
        onRefresh: widget.viewModel.load.execute,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SearchBar(
                elevation: WidgetStateProperty.all(0),
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromRGBO(218, 222, 220, 1),
                ),
                hintText: 'Buscar tienda...',
                leading: const Icon(Icons.search, color: Colors.grey),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: widget.viewModel.updateSearchQuery,
                trailing: [
                  if (widget.viewModel.isSearching)
                    IconButton(
                      icon: const Icon(Icons.filter_list_off),
                      onPressed: () => widget.viewModel.clearFilters(),
                    ),
                ],
              ),
              SizedBox(height: 20),
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
                                IncentiveFilterType.none,
                                vm,
                              ),
                              SizedBox(width: 12),
                              _buildFilterChip(
                                'Fecha',
                                IncentiveFilterType.date,
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
                              top: vm.currentFilter == IncentiveFilterType.none
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
                    child: widget.viewModel.incentives.isEmpty
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
                            itemCount: widget.viewModel.incentives.length,
                            itemBuilder: (context, index) {
                              final incentive =
                                  widget.viewModel.incentives[index];
                              return IncentiveCard(incentive: incentive);
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
  Widget _buildFilterContent(IncentivesViewModel vm, BuildContext context) {
    switch (vm.currentFilter) {
      case IncentiveFilterType.date:
        return _buildDateSelector(vm, context);
      case IncentiveFilterType.none:
      default:
        return const SizedBox.shrink(); // No muestra nada
    }
  }

  Widget _buildFilterChip(
    String label,
    IncentiveFilterType type,
    IncentivesViewModel vm,
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

  Widget _buildDateSelector(IncentivesViewModel vm, BuildContext context) {
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

class IncentiveCard extends StatelessWidget {
  final Incentive incentive;

  const IncentiveCard({super.key, required this.incentive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.incentiveDetails, extra: incentive),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            // --- 1. CONTENIDO BASE (No posicionado: Define el tamaño del Stack) ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Usamos el método de icono que tenías creado
                  _buildTypeIcon(
                    _VisualData(Icons.card_giftcard, Colors.green),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incentive.storeCommercialName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${incentive.amount} \$',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        // Espacio extra abajo para evitar que el contenido choque con la etiqueta posicionada
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- 2. ELEMENTO POSICIONADO (Flota sobre el tamaño definido arriba) ---
            Positioned(
              bottom: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Activo", // Cambia esto por el estado real si lo requieres
                  style: TextStyle(
                    color: Colors.green[800],
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

  // Widget auxiliar para el icono redondo (Corregido .withValues)
  Widget _buildTypeIcon(_VisualData data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(data.icon, color: data.color, size: 32),
    );
  }
}

class _VisualData {
  final IconData icon;
  final Color color;
  _VisualData(this.icon, this.color);
}
