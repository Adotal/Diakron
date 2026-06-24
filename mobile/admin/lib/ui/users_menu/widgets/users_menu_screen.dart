import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/core/themes/colors.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UsersMenuScreen extends StatelessWidget {
  const UsersMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the menu items
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Administradores', 'icon': Icons.admin_panel_settings, 'route': Routes.admins},
      {'title': 'Centros de recolección', 'icon': Icons.hub, 'route': Routes.collectionCenters},
      {'title': 'Participantes', 'icon': Icons.people, 'route': Routes.participants},
      {'title': 'Tiendas', 'icon': Icons.store, 'route': Routes.stores},
      {'title': 'Recolectores', 'icon': Icons.delivery_dining, 'route': Routes.collectors},
    ];

    return CustomScreen(
      title: 'Gestión de usuarios',
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.grey[100],
            leading: Icon(item['icon'] as IconData, color: AppColors.greenDiakron1),
            title: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(item['route']),
          );
        },
      ),
    );
  }
}