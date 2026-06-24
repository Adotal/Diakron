import 'package:diakron_participant/l10n/app_localizations.dart';
import 'package:diakron_participant/routing/routes.dart';
import 'package:diakron_participant/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_participant/ui/core/themes/dimens.dart';
import 'package:diakron_participant/ui/core/ui/custom_screen.dart';
import 'package:diakron_participant/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_participant/ui/core/ui/custom_text_form_field.dart';
import 'package:diakron_participant/ui/core/ui/form_button.dart';
import 'package:diakron_participant/utils/displayable_exception.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:diakron_participant/utils/validation/validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key, required this.viewModel});

  final SignupViewModel viewModel;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form validations
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surnames = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.signup.addListener(_onSignUpResult);
  }

  @override
  void didUpdateWidget(covariant SignupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.signup.removeListener(_onSignUpResult);
    widget.viewModel.signup.addListener(_onSignUpResult);
  }

  @override
  void dispose() {
    widget.viewModel.signup.removeListener(_onSignUpResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: AppLocalizations.of(context)!.createAccount,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.formPaddingHorizontal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  CustomTextFormField(
                    controller: _name,
                    labelText: AppLocalizations.of(context)!.names,
                    validator: Validators.required,
                  ),
                  const SizedBox(height: Dimens.paddingVertical),

                  CustomTextFormField(
                    controller: _surnames,
                    labelText: AppLocalizations.of(context)!.surnames,
                    validator: Validators.required,
                  ),
                  const SizedBox(height: Dimens.paddingVertical),

                  // Campo Email
                  CustomTextFormField(
                    controller: _email,
                    labelText: AppLocalizations.of(context)!.email,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: Dimens.paddingVertical),

                  CustomTextFormField(
                    controller: _phoneNumber,
                    labelText: AppLocalizations.of(context)!.phoneNumber,
                    validator: Validators.phoneNumber,
                  ),
                  const SizedBox(height: Dimens.paddingVertical),

                  // Campo Contraseña
                  CustomTextFormField(
                    controller: _password,
                    labelText: AppLocalizations.of(context)!.password,
                    // isPassword: true,
                    validator: Validators.required,
                    isPassword: true,
                  ),
                  const SizedBox(height: Dimens.paddingVertical),
                  // Field confirm password
                  CustomTextFormField(
                    controller: _confirmPassword,
                    labelText: AppLocalizations.of(context)!.confirmPassword,
                    // isPassword: true
                    validator: Validators.required,
                    isPassword: true,
                  ),

                  const SizedBox(height: 35),

                  // Button for signing up
                  FormButton(
                    text: AppLocalizations.of(context)!.signUp,
                    onPressed: () {
                      _handleSignUp();
                    },
                    listenable: widget.viewModel.signup,
                  ),

                  const SizedBox(height: Dimens.longPaddingVertical),

                  GestureDetector(
                    onTap: () {
                      context.go(Routes.login);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.haveAnAccount,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        SizedBox(width: 5),

                        Text(
                          AppLocalizations.of(context)!.loginExclamation,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Dimens.paddingVertical),
                  Text(
                    AppLocalizations.of(context)!.termsAndConditions,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: Dimens.paddingVertical),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignUpResult() {
    if (widget.viewModel.signup.completed) {
      widget.viewModel.signup.clearResult();

      CustomSnackBar.showSuccess(context, message: "Usuario registrado");
      context.go(Routes.login);
    }

    if (widget.viewModel.signup.error) {
      final errorResult = widget.viewModel.signup.result! as Failure<void>;
      widget.viewModel.signup.clearResult();

      DisplayableException dispExp = DisplayableException("Unknow error");

      if (errorResult.error is DisplayableException) {
        dispExp = errorResult.error as DisplayableException;
      } else {
        // Print non-displayable errors to console for debug
        debugPrint("Unhandled background error: ${errorResult.error}");
      }

      if (mounted) {
        CustomSnackBar.showError(
          context,
          title: "Error en registro",
          message: "$dispExp",
        );
      }
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.signup.execute((
        _name.value.text,
        _surnames.value.text,
        _email.value.text,
        _phoneNumber.value.text,
        _password.value.text,
        _confirmPassword.value.text,
      ));
    }
  }
}
