import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key, required this.viewModel});

  final LogoutViewModel viewModel;

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.logout.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    oldWidget.viewModel.logout.removeListener(_onResult);
    widget.viewModel.logout.addListener(_onResult);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.viewModel.logout.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.logout,
      builder: (context, _) {
        return IconButton(
          icon: widget.viewModel.logout.running
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.logout_rounded, color: Colors.grey),
          onPressed: () => widget.viewModel.logout.execute(),
        );
      },
    );
  }

  void _onResult() {
    if (widget.viewModel.logout.completed) {
      widget.viewModel.logout.clearResult();
      context.go(Routes.login);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout successful')));
    }
    if (widget.viewModel.logout.error) {
      final error = widget.viewModel.logout.result;

      widget.viewModel.logout.clearResult();
      context.go(Routes.login);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}
