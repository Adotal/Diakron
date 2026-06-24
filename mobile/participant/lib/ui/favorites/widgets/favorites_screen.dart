import 'package:diakron_participant/ui/core/themes/colors.dart';
import 'package:diakron_participant/ui/core/ui/error_indicator.dart';
import 'package:diakron_participant/ui/home/widgets/coupon_card_grid.dart';
import 'package:diakron_participant/ui/favorites/view_models/favorites_viewmodel.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, required this.viewModel});

  final FavoritesViewmodel viewModel;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.viewModel.coupons.isEmpty && !widget.viewModel.load.running) {
      widget.viewModel.load.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      body: ListenableBuilder(
        listenable: widget.viewModel,

        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.viewModel.load.error) {
            return ErrorIndicator(
              title: 'Error cargando favoritos',
              label: 'Recargar',
              onPressed: widget.viewModel.load.execute,
            );
          }

          return RefreshIndicator(
            onRefresh: () => widget.viewModel.load.execute(),

            child: CustomScrollView(
              slivers: [
                // HEADER
                SliverToBoxAdapter(child: _buildHeader(context)),
                // TITLE
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),

                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text(
                          widget.viewModel.isSearching
                              ? 'Resultados'
                              : 'Tus favoritos',

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        Text(
                          '${widget.viewModel.coupons.length} elementos',

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // EMPTY STATE
                if (widget.viewModel.coupons.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,

                    child: _buildEmptyState(),
                  )
                // GRID
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 18,
                            crossAxisSpacing: 18,
                            childAspectRatio: 0.78,
                          ),

                      delegate: SliverChildBuilderDelegate((context, index) {
                        final coupon = widget.viewModel.coupons[index];

                        return CouponCardGrid(coupon: coupon);
                      }, childCount: widget.viewModel.coupons.length),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 24),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.greenDiakron4, AppColors.greenDiakron1],

          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Favoritos',

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Tus beneficios guardados',

                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),

                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              _buildPointsPill(),
            ],
          ),

          const SizedBox(height: 24),

          // SEARCH BAR
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),

                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: TextField(
              onChanged: widget.viewModel.updateSearchQuery,

              decoration: InputDecoration(
                hintText: 'Buscar favorito',

                hintStyle: TextStyle(color: Colors.grey.shade400),

                prefixIcon: const Icon(Icons.search, color: Colors.grey),

                suffixIcon: widget.viewModel.isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear),

                        onPressed: () => widget.viewModel.clearFilters(),
                      )
                    : null,

                border: InputBorder.none,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.confirmation_number, size: 18, color: Colors.white),

          const SizedBox(width: 6),

          Text(
            '${widget.viewModel.points}',

            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                color: AppColors.greenDiakron1.withOpacity(0.1),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.favorite_border,
                size: 50,
                color: AppColors.greenDiakron1,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'No tienes favoritos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Guarda beneficios para encontrarlos rápidamente aquí.',

              textAlign: TextAlign.center,

              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
