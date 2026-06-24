import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/ui/line_chart_section.dart';
import 'package:diakron_admin/ui/core/ui/stat_card.dart';
import 'package:diakron_admin/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
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
    widget.viewModel.load.execute();
    widget.viewModel.logout.addListener(_onLogoutResult);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.viewModel != widget.viewModel) {
      widget.viewModel.load.execute();
    }
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onLogoutResult);
    super.dispose();
  }

  void _onLogoutResult() {
    if (widget.viewModel.logout.completed) {
      widget.viewModel.logout.clearResult();
      context.go(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenDiakron1,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            pinned: true, // Keep the top fixed
            automaticallyImplyLeading: false,
            expandedHeight: 200.0, // Total height when expanded
            backgroundColor: AppColors.greenDiakron1,
            elevation: 0,
            titleSpacing: 30.0,
            // It will always be visible even if you scroll.
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(                  
                  child: ListenableBuilder(
                    listenable: widget.viewModel.load,
                    builder: (context, _) {
                      if (widget.viewModel.load.running) {
                        // Reducimos el tamaño del indicador para que encaje en la línea de texto
                        return const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        );
                      } else if (widget.viewModel.load.error) {
                        return const Text(
                          "Error",                          
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          'Hola, ${widget.viewModel.admin.userName}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Si es muy largo, muestra "..."
                        );
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    _buildLogoutButton(),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),

            // It hides when scrolling
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight - 3,
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Panel Administrativo",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Tarjeta de estado del sistema original
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: Colors.yellow,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Estado del Sistema: Óptimo",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "35 segregadores operando con normalidad.",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main white card
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: const BoxDecoration(
                color: AppColors.backgroundDiakron,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 25.0,
                ),
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Resumen de impacto",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.viewModel.stats.length,
                            itemBuilder: (context, index) {
                              final data = widget.viewModel.stats[index];
                              final isSelected =
                                  widget.viewModel.selectedCardIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 12,
                                  bottom: 8,
                                ),
                                child: SizedBox(
                                  width: 180,
                                  child: StatCard(
                                    title: data.title,
                                    value: data.value,
                                    percentage: data.percentage,
                                    isDark: isSelected,
                                    progressColor: isSelected
                                        ? data.color
                                        : Colors.grey,
                                    onTap: () =>
                                        widget.viewModel.selectCard(index),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 35),
                        LineChartSection(
                          title: widget.viewModel.currentChartTitle,
                          selectedTab: widget.viewModel.selectedChartTab,
                          onTabChanged: (index) =>
                              widget.viewModel.selectChartTab(index),
                        ),
                        const SizedBox(height: 35),
                        LineChartSection(
                          title: widget.viewModel.currentChartTitle,
                          selectedTab: widget.viewModel.selectedChartTab,
                          onTabChanged: (index) =>
                              widget.viewModel.selectChartTab(index),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ListenableBuilder(
      listenable: widget.viewModel.logout,
      builder: (context, _) {
        return CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white24,
          child: IconButton(
            icon: widget.viewModel.logout.running
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () => widget.viewModel.logout.execute(),
          ),
        );
      },
    );
  }
}
