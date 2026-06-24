import 'package:diakron_admin/l10n/app_localizations.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_admin/ui/core/ui/custom_screen.dart';
import 'package:diakron_admin/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_admin/ui/core/ui/form_button.dart';
import 'package:diakron_admin/ui/core/ui/input_text.dart';
import 'package:diakron_admin/utils/displayable_exception.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.viewModel});

  final ForgotPasswordViewmodel viewModel;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.sendRecoverEmail.addListener(_sendRecoverEmail);
  }

  @override
  void didUpdateWidget(covariant ForgotPasswordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.sendRecoverEmail.removeListener(_sendRecoverEmail);
    widget.viewModel.sendRecoverEmail.addListener(_sendRecoverEmail);
  }

  @override
  void dispose() {
    widget.viewModel.sendRecoverEmail.removeListener(_sendRecoverEmail);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: AppLocalizations.of(context)!.forgotYourPassword,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25.0),
          children: [
            const SizedBox(height: 20),
            const Text(
              textAlign: TextAlign.center,
              "Escribe tu correo electrónico para restablecer tu contraseña:",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Campo Contraseña
            InputText(controller: _email, hintText: "Correo electrónico"),
            const SizedBox(height: 20),

            // BOTÓN ENVIAR CORREO
            FormButton(
              text: AppLocalizations.of(context)!.sendLink,
              onPressed: () {
                widget.viewModel.sendRecoverEmail.execute(_email.value.text);
              },
              listenable: widget.viewModel.sendRecoverEmail,
            ),
          ],
        ),
      ),
    );
  }

  void _sendRecoverEmail() {
    if (widget.viewModel.sendRecoverEmail.completed) {
      widget.viewModel.sendRecoverEmail.clearResult();

      CustomSnackBar.showSuccess(
        context,
        title: 'Revisa tu correo',
        message: "¡Link de recuperación enviado!",
      );

      context.go(Routes.login);
    }

    if (widget.viewModel.sendRecoverEmail.error) {
      final errorResult = widget.viewModel.sendRecoverEmail.result! as Failure;
      widget.viewModel.sendRecoverEmail.clearResult();

      DisplayableException dispExp = DisplayableException("Error inesperado");

      // Safely check if the inner exception is a DisplayableException
      if (errorResult.error is DisplayableException) {
        dispExp = errorResult.error as DisplayableException;
      } else {
        // Print non-displayable errors to console for debug
        debugPrint("Unhandled background error: ${errorResult.error}");
      }
      CustomSnackBar.showError(context, message: dispExp.message);
    }
  }
}
