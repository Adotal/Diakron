import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:diakron_collection_center/ui/auth/logout/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WaitingApprovalPage extends StatelessWidget {
  const WaitingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          LogoutButton(
            viewModel: LogoutViewModel(
              authRepository: context.read(),
              userRepository: context.read<CCenterRepository>(),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_empty, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                "Esperando validación",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Un administrador revisará tu información pronto. Por favor, espera.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text("Recargar estado"),
                onPressed: () async {
                  context.go(Routes.guard);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
