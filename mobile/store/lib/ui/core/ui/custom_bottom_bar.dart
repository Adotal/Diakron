import 'package:diakron_stores/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          // topLeft: Radius.circular(30),
          // topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          // topLeft: Radius.circular(30),
          // topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.greenDiakron1,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          onTap: onTap,

          items: [
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 0
                    ? Icons.grid_view_rounded
                    : Icons.grid_view_outlined,
              ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 1
                    ? Icons.article_rounded
                    : Icons.article_outlined,
              ),
              label: 'Actividad',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 2
                    ? Icons.qr_code_scanner_rounded
                    : Icons.qr_code_scanner_outlined,
                size: 30,
              ),
              label: 'Escanear',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 3
                    ? Icons.confirmation_number_rounded
                    : Icons.confirmation_number_outlined,
              ),
              label: 'Cupones',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 4 ? Icons.store_rounded : Icons.store_outlined,
              ),
              label: 'Tienda',
            ),
          ],
        ),
      ),
    );
  }
}
