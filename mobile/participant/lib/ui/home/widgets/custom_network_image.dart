import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({super.key, required this.urlImage});

  final String urlImage; // Good practice to type your variables!

  @override
  Widget build(BuildContext context) {
    const double size = 200.0; // Defined once to ensure consistency

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        urlImage,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey[100],
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            color: Colors.grey[200],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      ),
    );
  }
}