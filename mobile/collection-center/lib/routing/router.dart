// Routes manager
import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/waste_collection/waste_collection.dart';
import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_collection_center/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_collection_center/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_collection_center/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_collection_center/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_collection_center/ui/auth/reset_password/widgets/reset_password_screen.dart';
import 'package:diakron_collection_center/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_collection_center/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_collection_center/ui/collections/view_models/collections_view_model.dart';
import 'package:diakron_collection_center/ui/collections/widgets/collection_detail_screen.dart';
import 'package:diakron_collection_center/ui/collections/widgets/collections_screen.dart';
import 'package:diakron_collection_center/ui/guard/view_models/guard_viewmodel.dart';
import 'package:diakron_collection_center/ui/guard/widgets/guard_screen.dart';
import 'package:diakron_collection_center/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_collection_center/ui/home/widgets/home_screen.dart';
import 'package:diakron_collection_center/ui/main/widgets/main_screen.dart';
import 'package:diakron_collection_center/ui/payment_result/payment_result_screen.dart';
import 'package:diakron_collection_center/ui/profile/view_models/profile_view_model.dart';
import 'package:diakron_collection_center/ui/profile/widgets/profile_screen.dart';
import 'package:diakron_collection_center/ui/scanner/view_models/scanner_viewmodel.dart';
import 'package:diakron_collection_center/ui/scanner/widgets/scanner_screen.dart';
import 'package:diakron_collection_center/ui/stats/view_models/stats_viewmodel.dart';
import 'package:diakron_collection_center/ui/stats/widgets/stats_screen.dart';
import 'package:diakron_collection_center/ui/upload_files/widgets/privacy_policy_screen.dart';
import 'package:diakron_collection_center/ui/upload_files/widgets/upload_files_pages.dart';
import 'package:diakron_collection_center/ui/upload_files/widgets/upload_files_shell.dart';
import 'package:diakron_collection_center/ui/wating_approval/widgets/waiting_approval_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(
  AuthRepository authRepository,
  CCenterRepository userRepository,
) => GoRouter(
  initialLocation: Routes.guard,  
  debugLogDiagnostics: true, // TESTING
  refreshListenable: Listenable.merge([authRepository, userRepository]),
  redirect: _redirect,

  routes: [
    GoRoute(
      path: Routes.guard,
      builder: (context, state) {
        final viewModel = GuardViewModel(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<CCenterRepository>(),
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

    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              // Wrap the Home branch in the Provider so it stays alive during navigation
              child: Builder(
                builder: (context) {
                  // Use context.read()
                  final viewModel = HomeViewModel(
                    authRepository: context.read<AuthRepository>(),
                    ccenterRepository: context.read<CCenterRepository>(),
                  );
                  return HomeScreen(viewModel: viewModel);
                },
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),

        GoRoute(
          path: Routes.collections,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: ChangeNotifierProvider<CollectionsViewModel>(
                create: (context) => CollectionsViewModel(
                  ccenterRepository: context.read<CCenterRepository>(),
                ),
                child: Builder(
                  builder: (context) {
                    final viewModel = context.read<CollectionsViewModel>();
                    return CollectionsScreen(viewModel: viewModel);
                  },
                ),
              ),
            );
          },

          routes: [
            GoRoute(
              path: Routes.detailsRelative,
              builder: (context, state) {
                final collection = state.extra;

                if (collection is WasteCollection) {
                  return CollectionDetailScreen(collection: collection);
                }

                // Si por alguna razón el extra es nulo o tipo incorrecto,
                // rediriges o muestras un error elegante.
                return const Scaffold(
                  body: Center(
                    child: Text("Error: No se encontró la información."),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.scanner,
          builder: (context, state) {
            final viewModel = ScannerViewModel(
              authRepository: context.read<AuthRepository>(),
              ccenterRepository: context.read<CCenterRepository>(),
            );
            return ScannerScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.stats,
          builder: (context, state) {
            final viewModel = StatsViewModel(
              ccenterRepository: context.read<CCenterRepository>(),
            );
            return StatsScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.profile,
          builder: (context, state) {
            final viewModel = ProfileViewModel(
              authRepository: context.read<AuthRepository>(),
              cCenterRepository: context.read<CCenterRepository>(),
            );
            return ProfileScreen(viewModel: viewModel);
          },
        ),
      ],
    ),

    //------------------------Mercado Pago Deep Links---------------
    GoRoute(
      path: '/success', // GoRouter asocia el host del deep link al path
      builder: (context, state) {
        // Mercado Pago envía info en el query string (?payment_id=123...)
        final params = state.uri.queryParameters;
        return PaymentResultScreen(
          status: 'success',
          paymentId: params['payment_id'],
          externalReference: params['external_reference'],
        );
      },
    ),
    GoRoute(
      path: '/failure',
      builder: (context, state) => const PaymentResultScreen(status: 'failure'),
    ),
    GoRoute(
      path: '/pending',
      builder: (context, state) => const PaymentResultScreen(status: 'pending'),
    ),

    // GoRoute(
    //   path: Routes.home,
    //   pageBuilder: (context, state) => CustomTransitionPage(
    //     key: state.pageKey,
    //     child: HomeScreen(
    //       viewModel: HomeViewModel(
    //         authRepository: context.read<AuthRepository>(),
    //       ),
    //     ),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       // Use a simple fade so the pre-charged home page appears smoothly
    //       return FadeTransition(opacity: animation, child: child);
    //     },
    //   ),
    // ),
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
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final authRepo = context.read<AuthRepository>();
  final bool loggedIn = authRepo.isAuthenticated;

  // First check if recovering pswd
  if (authRepo.isRecoveringPassword) {
    return Routes.resetpassword;
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
