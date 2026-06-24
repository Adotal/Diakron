import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/core/ui/custom_screen.dart';
import 'package:diakron_stores/ui/core/ui/error_indicator.dart';
import 'package:diakron_stores/ui/coupons/table/view_models/coupons_viewmodel.dart';
import 'package:diakron_stores/ui/coupons/table/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key, required this.viewModel});

  final CouponsViewmodel viewModel;

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  void initState() {
    super.initState();
    _executeLoadIfEmpty();
  }

  @override
  void didUpdateWidget(covariant CouponsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-evaluate if the actual ViewModel instance changes.
    // Otherwise, parent rebuilds will trigger redundant checks/calls.
    if (widget.viewModel != oldWidget.viewModel) {
      _executeLoadIfEmpty();
    }
  }

  void _executeLoadIfEmpty() {
    if (!widget.viewModel.load.running &&
        widget.viewModel.load.result == null) {
      widget.viewModel.load.execute();
    }
  }

  // Removed empty dispose() to reduce boilerplate and method dispatch overhead.

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Cupones del negocio',
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.createCoupon),
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      child:
          // Merged Listenables to reduce widget tree depth
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.viewModel.load,
              widget.viewModel,
            ]),
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
              if (widget.viewModel.isDatabaseEmpty) {
                return Stack(
                  children: [
                    const Center(
                      child: Text(
                        'No hay cupones por ahora\n¡Puedes agregar el primero!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        size: const Size(double.infinity, double.infinity),
                        painter: ArrowPainter(),
                      ),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: () => widget.viewModel.load.execute(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SearchBar(
                        hintText: 'Buscar cupón...',
                        leading: const Icon(Icons.search),
                        // 1. Bind the text input directly to the ViewModel
                        onChanged: widget.viewModel.updateSearchQuery,
                        trailing: [
                          IconButton(
                            icon: const Icon(Icons.sort),
                            onPressed: () => _showFilterSheet(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              const SizedBox(height: 10),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildFilterChip(
                                      'Ninguno',
                                      CouponFilterType.none,
                                      vm,
                                    ),

                                    SizedBox(width: 12),
                                    _buildFilterChip(
                                      'Precio',
                                      CouponFilterType.price,
                                      vm,
                                    ),

                                    SizedBox(width: 12),
                                    _buildFilterChip(
                                      'Canjes',
                                      CouponFilterType.redeemTimes,
                                      vm,
                                    ),

                                    SizedBox(width: 12),
                                    _buildFilterChip(
                                      'Fecha',
                                      CouponFilterType.expirationDate,
                                      vm,
                                    ),

                                    SizedBox(width: 12),
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
                                    top:
                                        vm.currentFilter ==
                                            CouponFilterType.none
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

                    Expanded(
                      // Now this safely handles "0 search results" without destroying the screen
                      child: widget.viewModel.coupons.isEmpty
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
                              itemCount: widget.viewModel.coupons.length,
                              itemBuilder: (context, index) {
                                final coupon = widget.viewModel.coupons[index];
                                return CouponCard(coupon: coupon);
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite que el bottomsheet crezca
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            final vm = widget.viewModel;

            return FractionallySizedBox(
              heightFactor: 0.8, // Ocupa hasta el 80% de la pantalla
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SECCIÓN DE ORDENAMIENTO ---
                      Text(
                        'Ordenar por',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      _buildRadioTile("Sin orden", CouponSort.none, vm),
                      _buildRadioTile("Menor precio", CouponSort.priceAsc, vm),
                      _buildRadioTile("Mayor precio", CouponSort.priceDesc, vm),
                      _buildRadioTile(
                        "Próximos a caducar",
                        CouponSort.dateAsc,
                        vm,
                      ),
                      _buildRadioTile(
                        "Mayor tiempo de caducidad",
                        CouponSort.dateDesc,
                        vm,
                      ),
                      _buildRadioTile(
                        "Menos veces canjeado",
                        CouponSort.redeemAsc,
                        vm,
                      ),
                      _buildRadioTile(
                        "Más veces canjeado",
                        CouponSort.redeemDesc,
                        vm,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    CouponFilterType type,
    CouponsViewmodel vm,
  ) {
    final isSelected = vm.currentFilter == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.green.withOpacity(0.2),
      checkmarkColor: Colors.green,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green.shade800 : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) vm.updateFilterType(type);
      },
    );
  }

  // Enruta a la vista correspondiente según el filtro
  Widget _buildFilterContent(CouponsViewmodel vm, BuildContext context) {
    switch (vm.currentFilter) {
      case CouponFilterType.price:
        return _buildSliderSection(
          title: 'Rango de Precio',
          currentRange: vm.priceRange ?? RangeValues(0, vm.maxPrice),
          maxVal: vm.maxPrice,
          onChanged: vm.updatePriceRange,
        );
      case CouponFilterType.redeemTimes:
        return _buildSliderSection(
          title: 'Rango de Canjes',
          currentRange: vm.redeemRange ?? RangeValues(0, vm.maxRedeems),
          maxVal: vm.maxRedeems,
          onChanged: vm.updateRedeemRange,
        );
      case CouponFilterType.expirationDate:
        return _buildDateSelector(vm, context);
      case CouponFilterType.none:
      default:
        return const SizedBox.shrink(); // No muestra nada
    }
  }

  // Componente reutilizable para los Sliders
  Widget _buildSliderSection({
    required String title,
    required RangeValues currentRange,
    required double maxVal,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ${currentRange.start.round()} - ${currentRange.end.round()}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: currentRange,
          min: 0,
          max: maxVal,
          divisions: maxVal > 0 ? maxVal.toInt() : 100,
          labels: RangeLabels(
            currentRange.start.round().toString(),
            currentRange.end.round().toString(),
          ),
          activeColor: Colors.green,
          inactiveColor: Colors.green.withOpacity(0.2),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Componente mejorado para la selección de fechas
  Widget _buildDateSelector(CouponsViewmodel vm, BuildContext context) {
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
          const Icon(Icons.calendar_month, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasDate
                  ? '${DateFormat('dd/MMM/yy').format(vm.dateRange!.start)}  →  ${DateFormat('dd/MMM/yy').format(vm.dateRange!.end)}'
                  : 'Ninguna fecha seleccionada',
              style: TextStyle(
                color: hasDate ? Colors.black87 : Colors.black54,
                fontWeight: hasDate ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
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

  Widget _buildRadioTile(String title, CouponSort value, CouponsViewmodel vm) {
    return RadioListTile<CouponSort>(
      title: Text(title),
      value: value,
      groupValue: vm.currentSort,
      activeColor: Colors.green,
      contentPadding: EdgeInsets.zero, // Para que alinee mejor
      onChanged: (CouponSort? newValue) {
        if (newValue != null) {
          vm.updateSort(newValue);
          // Opcional: context.pop(); si quieres que se cierre al seleccionar
        }
      },
    );
  }
}

// Cuando hay 0 cupones, carga una flecha al botón de añadir nuevo
class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 24, 131, 5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Starting point (Right side of the text)
    Offset start = Offset(size.width * 0.8, size.height * 0.52);

    // Ending point (Just above the floating button)
    Offset end = Offset(size.width - 40, size.height - 100);

    // Control Point 1: Moves right (creates the horizontal start)
    Offset cp1 = Offset(size.width * 0.85, size.height * 0.52);

    // Control Point 2: Moves up from the end (creates the vertical approach)
    Offset cp2 = Offset(size.width - 40, size.height * 0.7);

    path.moveTo(start.dx, start.dy);

    // cubicTo creates the "loopy" 1/x feel
    path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, end.dx, end.dy);

    canvas.drawPath(path, paint);

    // --- Arrow fd (facing downwards) ---
    final arrowPath = Path();
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(end.dx - 12, end.dy - 12);
    arrowPath.moveTo(end.dx, end.dy);
    arrowPath.lineTo(end.dx + 12, end.dy - 12);

    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
