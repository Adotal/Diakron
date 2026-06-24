// Routes manager
import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/ui/activity/view_models/activity_view_model.dart';
import 'package:diakron_stores/ui/activity/widgets/activity_screen.dart';
import 'package:diakron_stores/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_stores/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_stores/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_stores/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_stores/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_stores/ui/auth/reset_password/widgets/reset_password_screen.dart';
import 'package:diakron_stores/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_stores/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_stores/ui/coupons/coupons_crud/view_models/create_coupon_viewmodel.dart';
import 'package:diakron_stores/ui/coupons/coupons_crud/view_models/rud_coupon_viewmodel.dart';
import 'package:diakron_stores/ui/coupons/coupons_crud/widgets/create_coupon_screen.dart';
import 'package:diakron_stores/ui/coupons/coupons_crud/widgets/rud_coupon_screen.dart';
import 'package:diakron_stores/ui/coupons/table/view_models/coupons_viewmodel.dart';
import 'package:diakron_stores/ui/coupons/table/widgets/coupons_screen.dart';
import 'package:diakron_stores/ui/guard/view_models/guard_viewmodel.dart';
import 'package:diakron_stores/ui/guard/widgets/guard_screen.dart';
import 'package:diakron_stores/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_stores/ui/home/widgets/home_screen.dart';
import 'package:diakron_stores/ui/main/widgets/main_screen.dart';
import 'package:diakron_stores/ui/profile/view_models/profile_viewmodel.dart';
import 'package:diakron_stores/ui/profile/widgets/profle_screen.dart';
import 'package:diakron_stores/ui/scanner/view_models/scanner_viewmodel.dart';
import 'package:diakron_stores/ui/scanner/widgets/scanner_screen.dart';
import 'package:diakron_stores/ui/upload_files/widgets/privacy_policy_screen.dart';
import 'package:diakron_stores/ui/upload_files/widgets/upload_files_pages.dart';
import 'package:diakron_stores/ui/upload_files/widgets/upload_files_shell.dart';
import 'package:diakron_stores/ui/wating_approval/widgets/waiting_approval_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.guard,
  debugLogDiagnostics: true, // TESTING
  refreshListenable: authRepository,
  redirect: _redirect,

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: HomeScreen(
              viewModel: HomeViewModel(
                // authRepository: context.read<AuthRepository>(),
                userRepository: context.read<StoreRepository>(),
              ),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Use a simple fade so the pre-charged home page appears smoothly
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          path: Routes.activity,
          builder: (context, state) {
            final viewModel = ActivityViewModel(
              userRepository: context.read<StoreRepository>(),
            );
            return ActivityScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.scanner,
          builder: (context, state) {
            final viewModel = ScannerViewModel(
              userRepository: context.read<StoreRepository>(),
              authRepository: context.read<AuthRepository>(),
            );
            return ScannerScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.coupons,
          builder: (context, state) {
            // return CouponDetailsScreen();
            final viewModel = CouponsViewmodel(
              userRepository: context.read<StoreRepository>(),
            );
            return CouponsScreen(viewModel: viewModel);
          },
          routes: [
            GoRoute(
              path: Routes
                  .createRelative, // This matches the ${center.id} in your push
              builder: (context, state) {
                final viewModel = CreateCouponViewmodel(
                  userRepository: context.read<StoreRepository>(),
                );
                return CreateCouponScreen(viewModel: viewModel);
              },
            ),

            GoRoute(
              path: ':id', // This matches the ${center.id} in your push
              builder: (context, state) {
                final String idString = state.pathParameters['id']!;
                // Extract the ID from the URL path
                final viewModel = RUDCouponViewmodel(
                  userRepository: context.read<StoreRepository>(),
                  couponId: int.parse(idString),
                );
                return RUDCouponScreen(viewModel: viewModel);
              },
            ),
          ],
        ),

        GoRoute(
          path: Routes.profile,
          builder: (context, state) {

            final showSuccess = state.uri.queryParameters['success_mp'] == 'true';
            final viewModel = ProfileViewmodel(
              storeRepository: context.read<StoreRepository>(),
              authRepository: context.read<AuthRepository>(),
            );
            return ProfileScreen(viewModel: viewModel, showSuccessMp: showSuccess,);
          },
        ),
      ],
    ),

    GoRoute(
      path: Routes.guard,
      builder: (context, state) {
        final viewModel = GuardViewModel(
          authRepository: context.read<AuthRepository>(),
          storeRepository: context.read<StoreRepository>(),
        );
        return GuardScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        final viewModel = LoginViewModel(
          authRepository: context.read<AuthRepository>(),
        );
        return LoginScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.forgotpassword,
      builder: (context, state) {
        final viewModel = ForgotPasswordViewmodel(
          authRepository: context.read<AuthRepository>(),
        );
        return ForgotPasswordScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.resetpassword,
      builder: (context, state) {
        final viewModel = ResetPasswordViewmodel(
          authRepository: context.read<AuthRepository>(),
        );
        return ResetPasswordScreen(viewModel: viewModel);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        // Here are progress bar and button

        return UploadFilesShell(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.uploadData,
          builder: (context, state) => const UploadFilesStep1Page(),
        ),
        GoRoute(
          path: Routes.uploadData2,
          builder: (context, state) => const UploadFilesStep2Page(),
        ),
        GoRoute(
          path: Routes.uploadData3,
          builder: (context, state) => const UploadFilesStep3Page(),
        ),
        GoRoute(
          path: Routes.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
      ],
    ),
    GoRoute(
      path: Routes.signup,
      builder: (context, state) {
        final viewModel = SignupViewModel(
          authRepository: context.read<AuthRepository>(),
        );
        return SignupScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.waitingApproval,
      builder: (context, state) {
        // final viewModel = SignupViewModel(
        //   authRepository: context.read<AuthRepository>(),
        // );
        return WaitingApprovalPage();
      },
    ),
        //------------------------Mercado Pago Deep Links---------------
    GoRoute(
      path: '/success-linking', // GoRouter asocia el host del deep link al path
      redirect: (context, state) {
        // Redirección inmediata y limpia sin montar ningún Widget problemático
        return '${Routes.profile}?success_mp=true';
        // return const MpLinkingHandler();        
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final authRepo = context.read<AuthRepository>();
  final bool loggedIn = authRepo.isAuthenticated;

  // First check if recovering pswd
  if (authRepo.isRecoveringPassword) {
    return Routes.resetpassword;
  }

  // FIX LATER
  if (state.matchedLocation.contains(Routes.forgotpassword)) {
    return null;
  }
  
  // Auth Check
  final bool isAtAuthPage = [
    Routes.login,
    Routes.signup,
    Routes.forgotpassword,
    // Routes.resetpassword
  ].contains(state.matchedLocation);

  if (!loggedIn) {
    return isAtAuthPage ? null : Routes.login;
  }

  if (authRepo.isVerifyingAuth) {
    return null;
  }

  // If logged in but we are at Login, or we just started, go to the Guard
  if (isAtAuthPage || state.matchedLocation == '/') {
    return Routes.guard;
  }

  return null;
}
