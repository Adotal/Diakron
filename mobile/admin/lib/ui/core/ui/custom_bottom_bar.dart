import 'package:diakron_admin/ui/core/themes/colors.dart';
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
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: currentIndex,
          selectedItemColor: AppColors.greenDiakron1,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11,),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11,),
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(currentIndex == 0 ? Icons.grid_view_rounded : Icons.grid_view_outlined),
              ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(currentIndex == 1 ? Icons.location_on_rounded : Icons.location_on_outlined),
              ),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(currentIndex == 2 ? Icons.people_alt_rounded : Icons.people_alt_outlined),
              ),
              label: 'Usuarios',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(currentIndex == 3 ? Icons.account_balance_wallet_rounded : Icons.account_balance_wallet_outlined),
              ),
              label: 'Finanzas',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Icon(currentIndex == 4 ? Icons.settings_rounded : Icons.settings_outlined),
              ),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}