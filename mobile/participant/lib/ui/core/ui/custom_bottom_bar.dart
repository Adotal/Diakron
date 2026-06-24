import 'package:diakron_participant/ui/core/themes/colors.dart';
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
            color: Colors.black12,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
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
              currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_outlined,
            ),
            label: 'Favoritos',
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
                  ? Icons.map_rounded
                  : Icons.map_outlined,
            ),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 4 ? Icons.person_rounded : Icons.person_outline,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
