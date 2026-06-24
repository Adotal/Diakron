import 'package:diakron_participant/data/repositories/auth/auth_repository.dart';
import 'package:diakron_participant/data/repositories/map/map_repository_impl.dart';
import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/routing/routes.dart';
import 'package:diakron_participant/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_participant/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_participant/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_participant/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_participant/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_participant/ui/auth/reset_password/widgets/reset_password_screen.dart';
import 'package:diakron_participant/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_participant/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_participant/ui/home/coupon_details/view_models/coupon_detail_viewmodel.dart';
import 'package:diakron_participant/ui/home/coupon_details/widgets/coupon_detail_screen.dart';
import 'package:diakron_participant/ui/map/view_models/map_viewmodel.dart';
import 'package:diakron_participant/ui/map/widgets/map_screen.dart';
import 'package:diakron_participant/ui/profile/view_models/profile_viewmodel.dart';
import 'package:diakron_participant/ui/profile/widgets/proflie_screen.dart';
import 'package:diakron_participant/ui/favorites/view_models/favorites_viewmodel.dart';
import 'package:diakron_participant/ui/favorites/widgets/favorites_screen.dart';
import 'package:diakron_participant/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_participant/ui/home/widgets/home_screen.dart';
import 'package:diakron_participant/ui/main/widgets/main_screen.dart';
import 'package:diakron_participant/ui/qr_coupon/view_models/qr_coupon_viewmodel.dart';
import 'package:diakron_participant/ui/qr_coupon/widgets/qr_coupon_screen.dart';
import 'package:diakron_participant/ui/scanner/view_models/scanner_viewmodel.dart';
import 'package:diakron_participant/ui/scanner/widgets/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,  
  debugLogDiagnostics: true, // TESTING
  refreshListenable: authRepository,
  redirect: _redirect,

  routes: [
    GoRoute(
      path:
          '${Routes.qrCoupon}/:userId/:couponId', // Definimos los parámetros en el path
      name: Routes.qrCoupon,
      builder: (context, state) {
        // Extraemos los parámetros y los convertimos a int
        final userId = state.pathParameters['userId']!;
        final couponId = int.parse(state.pathParameters['couponId']!);
        final viewModel = QRCouponViewmodel(
          authRepository: context.read<AuthRepository>(),
          couponId: couponId,
          userId: userId,
        );

        return QRCouponScreen(viewModel: viewModel);
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
              child: ChangeNotifierProvider<HomeViewModel>(
                create: (context) => HomeViewModel(
                  participantRepository: context.read<ParticipantRepository>(),
                ),
                // Use a Builder to access the newly created Provider context safely
                child: Builder(
                  builder: (context) {
                    // Use context.read()
                    final viewModel = context.read<HomeViewModel>();
                    return HomeScreen(viewModel: viewModel);
                  },
                ),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
          routes: [
            GoRoute(
              path: ':id', // This matches the ${center.id} in your push
              builder: (context, state) {
                final String idString = state.pathParameters['id']!;
                // Extract the ID from the URL path
                final viewModel = CouponDetailViewmodel(
                  participantRepository: context.read<ParticipantRepository>(),
                  couponId: int.parse(idString),
                );
                return CouponDetailScreen(viewModel: viewModel);
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.favorites,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              // Wrap the Home branch in the Provider so it stays alive during navigation
              child: ChangeNotifierProvider<FavoritesViewmodel>(
                create: (context) => FavoritesViewmodel(
                  participantRepository: context.read<ParticipantRepository>(),
                ),
                // Use a Builder to access the newly created Provider context safely
                child: Builder(
                  builder: (context) {
                    // Use context.read()
                    final viewModel = context.read<FavoritesViewmodel>();
                    return FavoritesScreen(viewModel: viewModel);
                  },
                ),
              ),
            );
          },
        ),

        GoRoute(
          path: Routes.scanner,
          builder: (context, state) {
            final viewModel = ScannerViewModel(
              authRepository: context.read<AuthRepository>(),
              participantRepository: context.read<ParticipantRepository>(),
            );
            return ScannerScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.map,
          builder: (context, state) {
            final viewModel = MapViewModel(
              mapRepository: MapRepositoryImpl(),
              participantRepository: context.read<ParticipantRepository>(),
            );
            return MapScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.profile,
          builder: (context, state) {
            return ProfileScreen(
              viewModel: ProfileViewmodel(
                participantRepository: context.read(),
                authRepository: context.read(),
              ),
            );
          },
        ),
      ],
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
    GoRoute(
      path: Routes.signup,
      builder: (context, state) {
        final viewModel = SignupViewModel(
          authRepository: context.read<AuthRepository>(),
        );
        return SignupScreen(viewModel: viewModel);
      },
    ),
  ],
);
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final authRepo = context.read<AuthRepository>();

  final bool loggedIn = authRepo.isAuthenticated;
  // Auth Check
  final bool isAtAuthPage = [
    Routes.login,
    Routes.signup,
    Routes.forgotpassword,
    Routes.resetpassword,
  ].contains(state.matchedLocation);

  // // Locations
  final bool isAtLogin = state.matchedLocation == Routes.login;

  // Password Recovery
  if (authRepo.isRecoveringPassword) {
    return Routes.resetpassword;
  }

  // If not logged in and not in auth page go to Login
  if (!loggedIn) {
    return isAtAuthPage ? null : Routes.login;
  }

  if (authRepo.isVerifyingAuth) {
    return null;
  }

  // Logged in in login go Home
  if (loggedIn && isAtLogin) {
    return Routes.home;
  }

  return null;
}
