import 'package:diakron_collectors/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({
    this.actions,
    super.key,
    required this.child,
    this.floatingActionButtonLocation,
    this.floatingActionButton,
    required this.title,
  });

  final Widget child;
  final String title;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.greenDiakron1,
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      backgroundColor: AppColors.greenDiakron1, // El verde de Diakron
      body: Column(
        children: [
          // Cuerpo de la app)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45.0),
                  topLeft: Radius.circular(45.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                  topRight: Radius.circular(45.0),
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}