import 'package:diakron_participant/routing/routes.dart';
import 'package:diakron_participant/ui/core/ui/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  // Top level destinations
  static const List<String> _destinations = [
    Routes.home,
    Routes.favorites,
    Routes.scanner,
    Routes.map,
    Routes.profile,
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    
    // Find the index of the destination that matches the start of the current path
    final index = _destinations.indexWhere((route) => location.startsWith(route));
    
    // If not foundor in root default to 0
    return index == -1 ? 0 : index;
  }

  void _onItemTapped(int index, BuildContext context) {
    context.go(_destinations[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}