import 'package:diakron_stores/models/incentive/incentive.dart';
import 'package:diakron_stores/ui/activity/view_models/activity_view_model.dart';
import 'package:diakron_stores/ui/core/ui/custom_screen.dart';
import 'package:diakron_stores/ui/core/ui/error_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesario para DateFormat y NumberFormat

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.viewModel});

  final ActivityViewModel viewModel;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load.execute();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Incentivos',
      // Eliminamos el SingleChildScrollView, ahora solo usamos Padding y Column
      child: RefreshIndicator(
        onRefresh: widget.viewModel.load.execute,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  return _buildDateSelector(widget.viewModel, context);
                },
              ),
              const SizedBox(height: 30),

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
                            padding: EdgeInsets.zero,
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

  Widget _buildDateSelector(ActivityViewModel vm, BuildContext context) {
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

// WIDGET: IncentiveCard

class IncentiveCard extends StatelessWidget {
  final Incentive incentive;

  const IncentiveCard({super.key, required this.incentive});

  @override
  Widget build(BuildContext context) {
    // Formateadores para MXN y fechas legibles
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
      decimalDigits: 2,
    );
    // Asumiendo que incentive tiene una propiedad llamada 'date' tipo DateTime
    final dateFormat = DateFormat('dd MMM yyyy – kk:mm', 'es');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Un borde sutil en lugar de sombras pesadas (estilo minimalista)
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Lado Izquierdo: Fecha y Porcentaje
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Representación: ${incentive.repPercentage}%',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                dateFormat.format(incentive.createdAt.toLocal()),
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Lado Derecho: Monto en MXN
          Text(
            currencyFormat.format(incentive.amount),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Componente mejorado para la selección de fechas
}
