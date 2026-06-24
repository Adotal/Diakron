import 'package:diakron_stores/ui/core/themes/colors.dart';
import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/error_indicator.dart';
import 'package:diakron_stores/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => widget.viewModel.load.execute(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Verde
            Container(
              padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
              decoration: BoxDecoration(
                color: AppColors.greenDiakron1,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/man_stonks.png',
                    height: 200,
                  ), // Placeholder
                  SizedBox(width: Dimens.paddingHorizontal),
                  Expanded(
                    child: Text(
                      '¡Hola! Tenemos todo preparado para hacer un mundo mejor con tu negocio.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ListenableBuilder(
                listenable: widget.viewModel.load,
                builder: (context, _) {
                  if (widget.viewModel.load.running) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (widget.viewModel.load.error) {
                    return ErrorIndicator(
                      title: 'Error cargando datos',
                      label: 'Intentar de nuevo',
                      onPressed: widget.viewModel.load.execute,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => widget.viewModel.load.execute(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatItem(
                          'Clientes que canjearon su primer cupón',
                          '${widget.viewModel.store!.firstExchangesParticipant}',
                          Icons.people_alt,
                        ),
                        _buildStatItem(
                          'Cupones del negocio',
                          '${widget.viewModel.manyCoupons}',
                          Icons.confirmation_number,
                        ),
                        _buildStatItem(
                          'Puntos canjeados por el negocio',
                          '${widget.viewModel.store!.pointsExchanged}',
                          Icons.celebration,
                        ),
                        // _buildRankSection(),
                        // SizedBox(height: 20),
                        // Text(
                        //   'Cupones mas canjeados',
                        //   style: TextStyle(
                        //     fontSize: 18,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        // _buildCouponList(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 30),
              const SizedBox(width: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankSection() {
    return Row(
      children: [
        Icon(Icons.insights),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '¡Felicidades! En este momento te encuentras en la posición #03',
          ),
        ),
      ],
    );
  }

  Widget _buildCouponList() {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _couponItem('Aguachile', '32 canjeos'),
          _couponItem('Ceviche', '51 canjeos'),
        ],
      ),
    );
  }

  Widget _couponItem(String name, String count) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(color: Colors.grey[300], height: 80, width: 120),
          ),
          Text(count, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
