import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/custom_screen.dart';
import 'package:diakron_stores/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_stores/ui/core/ui/form_button.dart';
import 'package:diakron_stores/ui/core/ui/input_text.dart';
import 'package:diakron_stores/utils/displayable_exception.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.viewModel});

  final ResetPasswordViewmodel viewModel;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.updatePassword.addListener(_onUpdatePassword);
  }

  @override
  void didUpdateWidget(covariant ResetPasswordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.updatePassword.removeListener(_onUpdatePassword);
    widget.viewModel.updatePassword.addListener(_onUpdatePassword);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onUpdatePassword);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'Reestablecer contraseña',
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25.0),
          children: [
            const Text(
              textAlign: TextAlign.center,
              "Escribe tu nueva contraseña",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: Dimens.paddingVertical),
            InputText(
              controller: _password,
              hintText: "Nueva contraseña",
              isPassword: true,
            ),
            const SizedBox(height: Dimens.paddingVertical),
            InputText(
              controller: _confirmPassword,
              hintText: "Confirmar contraseña",
              isPassword: true,
            ),
            const SizedBox(height: Dimens.paddingVertical),
            FormButton(
              text: "Reestablecer",
              onPressed: () {
                widget.viewModel.updatePassword.execute((
                  _password.value.text,
                  _confirmPassword.value.text,
                ));
              },
              listenable: widget.viewModel.updatePassword,
            ),
            SizedBox(height: Dimens.paddingVertical),
          ],
        ),
      ),
    );
  }

  void _onUpdatePassword() {
    if (widget.viewModel.updatePassword.completed) {
      widget.viewModel.updatePassword.clearResult();

      CustomSnackBar.showSuccess(
        context,
        message: 'Nueva contraseña actualizada',
      );
      context.go(Routes.login);
    }

    if (widget.viewModel.updatePassword.error) {
      final errorResult = widget.viewModel.updatePassword.result! as Failure;
      widget.viewModel.updatePassword.clearResult();

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
