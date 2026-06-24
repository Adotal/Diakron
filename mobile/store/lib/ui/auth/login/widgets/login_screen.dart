import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/l10n/app_localizations.dart';
import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_stores/ui/core/themes/app_strings.dart';
import 'package:diakron_stores/ui/core/themes/colors.dart';
import 'package:diakron_stores/ui/core/themes/dimens.dart';
import 'package:diakron_stores/ui/core/ui/custom_snackbar.dart';
import 'package:diakron_stores/ui/core/ui/form_button.dart';
import 'package:diakron_stores/ui/core/ui/input_text.dart';
import 'package:diakron_stores/utils/displayable_exception.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _borderRadiusAnimation;
  bool _isAnimating = false;
  bool _showForm = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);

    // Configure animation
    _animationController = AnimationController(vsync: this, value: 0.35);
    _borderRadiusAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.viewModel.login.removeListener(_onResult);
    super.dispose();
  }

  Widget _buildStaticHeader(BuildContext context) {
    return Container(
      height: Dimens.screenSize(context).height * 0.35,
      decoration: const BoxDecoration(
        color: AppColors.greenDiakron1,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.recycling, size: 80, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              AppStrings.diakron,
              style: TextStyle(
                fontSize: Dimens.fontTitle,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.stores,
              style: const TextStyle(
                fontSize: Dimens.fontMedium,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.formPaddingHorizontal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.login,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: Dimens.fontSubtitle,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),

          InputText(
            controller: _email,
            hintText: AppLocalizations.of(context)!.email,
          ),
          const SizedBox(height: 20),

          InputText(
            controller: _password,
            hintText: AppLocalizations.of(context)!.password,
            isPassword: true,
          ),

          const SizedBox(height: 10),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Text(
          //       AppLocalizations.of(context)!.keepLogged,
          //       style: const TextStyle(color: Colors.grey),
          //     ),
          //     Checkbox(
          //       value: false,
          //       onChanged: (v) {},
          //       activeColor: const Color(0xFF387C11),
          //     ),
          //   ],
          // ),
          GestureDetector(
            onTap: () => context.push(Routes.forgotpassword),
            child: Text(
              AppLocalizations.of(context)!.forgotYourPassword,
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // Login button
          FormButton(
            text: AppLocalizations.of(context)!.login,
            onPressed: () {
              widget.viewModel.login.execute((_email.text, _password.text));
            },
            listenable: widget.viewModel.login,
          ),

          const SizedBox(height: Dimens.paddingVertical),

          GestureDetector(
            onTap: () => context.push(Routes.signup),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.wantToJoinUs,
                  style: const TextStyle(color: Colors.black54),
                ),
                Text(
                  AppLocalizations.of(context)!.signUp,
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
            style: TextStyle(fontSize: Dimens.fontSmall, color: Colors.grey),
          ),
          const SizedBox(height: Dimens.paddingVertical),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Login
          if (_showForm)
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildStaticHeader(context), // Header static
                  const SizedBox(height: 40),
                  _buildLoginForm(context), // form
                ],
              ),
            ),
          // Splash
          if (_isAnimating)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  // The height increases from 35% to 100% of the screen
                  height: size.height * _animationController.value,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: AppColors.greenDiakron1,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_borderRadiusAnimation.value),
                    ),
                  ),
                  child: OverflowBox(
                    maxHeight: size.height,
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 1.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo with centered text
                          const Icon(
                            Icons.recycling,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            AppStrings.diakron,
                            style: TextStyle(
                              fontSize: Dimens.fontTitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                          if (_animationController.value > 0.0) // 0.8
                            Text(
                              AppLocalizations.of(context)!.stores,
                              style: const TextStyle(
                                fontSize: Dimens.fontMedium,
                                color: Colors.white70,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _onResult() async {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      setState(() {
        _isAnimating = true;
        _showForm = true;
      });

      await _animationController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutQuart,
      );

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        _showForm = false;
      });

      await _animationController.animateBack(
        0.0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutQuart,
      );

      // Ve a home
      // UNLOCK ROUTER
      if (mounted) {
        context.read<AuthRepository>().unlockRouter();
      }
    }
    if (widget.viewModel.login.error) {
      final errorResult = widget.viewModel.login.result! as Failure<void>;
      widget.viewModel.login.clearResult();

      DisplayableException dispExp = DisplayableException("Unknow error");

      // Safely check if the inner exception is a DisplayableException
      if (errorResult.error is DisplayableException) {
        dispExp = errorResult.error as DisplayableException;
      } else {
        // Print non-displayable errors to console for debug
        debugPrint("Unhandled background error: ${errorResult.error}");
      }

      if (mounted) {
        CustomSnackBar.showError(
          context,
          title: "Error de Inicio de Sesión",
          message: dispExp.message,
        );
      }
    }
  }
}
