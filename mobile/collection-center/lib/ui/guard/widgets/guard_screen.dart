import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/ui/guard/view_models/guard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GuardScreen extends StatefulWidget {
  const GuardScreen({super.key, required this.viewModel});
  final GuardViewModel viewModel;

  @override
  State<GuardScreen> createState() => _GuardScreenState();
}

class _GuardScreenState extends State<GuardScreen> {
  @override
  void initState() {
    super.initState();
    _executeCheck();
  }

  void _executeCheck() async {
    await widget.viewModel.checkStatusCommand.execute();

    if (mounted && widget.viewModel.checkStatusCommand.completed) {
      final nextRoute = await widget.viewModel.getTargetRoute();
      context.go(nextRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: widget.viewModel.checkStatusCommand,
        builder: (context, _) {
          final command = widget.viewModel.checkStatusCommand;

          // 1. Error State with Try Again button
          if (command.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 64,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Error de conexión con Diakron",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "No pudimos validar tu estatus. Reintenta por favor.",
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _executeCheck,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reintentar"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthRepository>().logout();  
                        context.go(Routes.login);
                      },
                      child: const Text("Regresar al Login"),
                    ),
                  ],
                ),
              ),
            );
          }

          // 2. Loading State (Default)
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator()],
            ),
          );
        },
      ),
    );
  }
}
