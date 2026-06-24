import 'package:diakron_collectors/l10n/app_localizations.dart';
import 'package:diakron_collectors/routing/routes.dart';
import 'package:diakron_collectors/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_collectors/ui/core/themes/dimens.dart';
import 'package:diakron_collectors/ui/core/ui/form_button.dart';
import 'package:diakron_collectors/ui/core/ui/input_text.dart';
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
    return Scaffold(
      backgroundColor: const Color(0xFF387600), // El verde de Diakron
      body: Column(
        children: [
          // SECCIÓN SUPERIOR (AppBar Personalizada)
          SafeArea(
            bottom: false, // No padding abajo para que pegue con lo blanco
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4,
              ),
              width: double.infinity,
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                  const SizedBox(width: 30),
                  const Icon(Icons.recycling, color: Colors.white, size: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'DIAKRON',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cuerpo de la app)
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    45.0,
                  ), // Curva pronunciada de tu imagen
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(25.0),
                  children: [
                    const Text(
                      textAlign: TextAlign.center,
                      "¿Olvidaste tu\nContraseña?",
                      style: TextStyle(fontSize: 38),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      textAlign: TextAlign.start,
                      "Escribe tu correo electrónico para restablecer tu contraseña:",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    // Campo Contraseña
                    InputText(
                      controller: _email,
                      hintText: "Correo electrónico",
                    ),
                    const SizedBox(height: 20),

                    // BOTÓN ENVIAR CORREO
                    FormButton(
                      text: AppLocalizations.of(context)!.sendLink,
                      onPressed: () {
                        widget.viewModel.sendRecoverEmail.execute(
                          _email.value.text,
                        );
                      },
                      listenable: widget.viewModel.sendRecoverEmail,
                    ),

                    const SizedBox(height: Dimens.paddingVertical),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendRecoverEmail() {

    if (widget.viewModel.sendRecoverEmail.completed) {
      widget.viewModel.sendRecoverEmail.clearResult();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Revisa tu correo!')));

      context.go(Routes.login);
    }

    if (widget.viewModel.sendRecoverEmail.error) {
      final error = widget.viewModel.sendRecoverEmail.result;
      widget.viewModel.sendRecoverEmail.clearResult();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }
}
