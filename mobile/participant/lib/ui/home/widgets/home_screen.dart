import 'package:diakron_participant/models/store/store.dart';
import 'package:diakron_participant/ui/core/themes/colors.dart';
import 'package:diakron_participant/ui/core/ui/error_indicator.dart';
import 'package:diakron_participant/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_participant/ui/home/widgets/coupon_card_grid.dart';
import 'package:diakron_participant/ui/home/widgets/coupon_card_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      backgroundColor: Colors.grey.shade50, // background card
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, child) {
          if (widget.viewModel.load.running) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.greenDiakron1),
            );
          }

          if (widget.viewModel.selectedStore != null) {
            return _buildStoreDetailView(widget.viewModel.selectedStore!);
          }

          if (widget.viewModel.load.error) {
            return Center(
              child: ErrorIndicator(
                title: 'Error cargando información',
                label: 'Recargar',
                onPressed: widget.viewModel.load.execute,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => widget.viewModel.load.execute(),
            child: CustomScrollView(
              slivers: [
                // head
                SliverToBoxAdapter(child: _buildDidiHeader(context)),

                // PHRASE
                if (!widget.viewModel.isSearching &&
                    widget.viewModel.participant.phrase != null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _ExpandablePhraseCard(
                        phrase: widget.viewModel.participant.phrase!,
                      ),
                    ),
                  ),

                // Popular shops
                if (!widget.viewModel.isSearching)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
                          child: Text(
                            "Tiendas Más Populares",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 135,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: widget.viewModel.popularStores.length,
                            itemBuilder: (context, index) {
                              final store =
                                  widget.viewModel.popularStores[index];
                              return _buildStoreCard(store);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // Vertical list title
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 15),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.viewModel.isSearching
                              ? "Resultados de búsqueda"
                              : "Todos los beneficios",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Benefits grid
                if (widget.viewModel.isDisplayingGrouped)
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final store = widget.viewModel.groupedCoupons.keys
                          .elementAt(index);
                      final coupons = widget.viewModel.groupedCoupons[store]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundImage: NetworkImage(store.urlLogo),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  store.commercialName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: coupons.length,
                              itemBuilder: (context, i) => Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: SizedBox(
                                  width: 160,
                                  child: CouponCardGrid(coupon: coupons[i]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }, childCount: widget.viewModel.groupedCoupons.length),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.78,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => CouponCardGrid(
                          coupon: widget.viewModel.coupons[index],
                        ),
                        childCount: widget.viewModel.coupons.length,
                      ),
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

  // ===========================================================================
  // WIDGETS PRIVADOS
  // ===========================================================================

  Widget _buildDidiHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.greenDiakron4, AppColors.greenDiakron1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¡Hola, ${widget.viewModel.participant.userName}!',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              _buildPointsPill(),
            ],
          ),

          const SizedBox(height: 20),

          // BARRA DE BÚSQUEDA
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: widget.viewModel.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Busca un beneficio',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // filtros
                    IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: AppColors.greenDiakron1,
                      ),
                      onPressed: () => _showFilterSheet(context),
                    ),

                    // clear
                    if (widget.viewModel.isSearching)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          widget.viewModel.clearFilters();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // pestañas
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => widget.viewModel.updateCategory("Todos"),
                  child: _buildTabItem(
                    "Todos",
                    widget.viewModel.selectedCategory == "Todos",
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.viewModel.updateCategory("Restaurante"),
                  child: _buildTabItem(
                    "Restaurante",
                    widget.viewModel.selectedCategory == "Restaurante",
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.viewModel.updateCategory("General"),
                  child: _buildTabItem(
                    "General",
                    widget.viewModel.selectedCategory == "General",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.confirmation_number, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          ListenableBuilder(
            listenable: widget.viewModel.load,
            builder: (context, child) {
              if (widget.viewModel.load.running) {
                return const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                );
              }
              return Text(
                '${widget.viewModel.points}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Pestañas inferiores de la cabecera
  Widget _buildTabItem(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 4),
            Container(height: 2, width: 24, color: Colors.white),
          ],
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ordenar por',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRadioTile("Sin filtro", CouponSort.none),
                    _buildRadioTile("Menor precio", CouponSort.priceAsc),
                    _buildRadioTile("Mayor precio", CouponSort.priceDesc),
                    _buildRadioTile("Próximos a caducar", CouponSort.dateAsc),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadioTile(String title, CouponSort value) {
    return RadioListTile<CouponSort>(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      value: value,
      groupValue: widget.viewModel.currentSort,
      activeColor: AppColors.greenDiakron1,
      onChanged: (CouponSort? newValue) {
        if (newValue != null) {
          widget.viewModel.updateSort(newValue);
          context.pop();
        }
      },
    );
  }

  Widget _buildStoreCard(Store store) {
    return GestureDetector(
      onTap: () => widget.viewModel.selectStore(store),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(store.urlLogo, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              store.commercialName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreDetailView(Store store) {
    final storeCoupons = widget.viewModel.coupons
        .where((coupon) => coupon.idStore == store.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          // HEADER IMAGE
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => widget.viewModel.selectStore(null),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    store.urlLogo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.store, size: 80),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // STORE INFO
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text(
                    store.commercialName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    store.address,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Cupones disponibles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // COUPONS LIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final coupon = storeCoupons[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CouponCardList(coupon: coupon),
                );
              }, childCount: storeCoupons.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _ExpandablePhraseCard extends StatefulWidget {
  const _ExpandablePhraseCard({required this.phrase});

  final String phrase;

  @override
  State<_ExpandablePhraseCard> createState() => _ExpandablePhraseCardState();
}

class _ExpandablePhraseCardState extends State<_ExpandablePhraseCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {
          setState(() {
            expanded = !expanded;
          });
        },

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON
            Container(
              width: 34,
              height: 34,

              decoration: BoxDecoration(
                color: AppColors.greenDiakron1.withOpacity(0.12),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.auto_awesome,
                size: 18,
                color: AppColors.greenDiakron1,
              ),
            ),

            const SizedBox(width: 12),

            // TEXT
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      widget.phrase,

                      maxLines: expanded ? null : 2,
                      overflow: expanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Text(
                          expanded ? 'Mostrar menos' : 'Leer más',

                          style: const TextStyle(
                            color: AppColors.greenDiakron1,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 4),

                        AnimatedRotation(
                          turns: expanded ? 0.5 : 0,

                          duration: const Duration(milliseconds: 250),

                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.greenDiakron1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
