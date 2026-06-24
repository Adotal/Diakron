// Routes manager
import 'package:diakron_collectors/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collectors/data/repositories/map/map_repository_impl.dart';
import 'package:diakron_collectors/data/repositories/user/collector_repository.dart';
import 'package:diakron_collectors/data/services/location_service.dart';
import 'package:diakron_collectors/models/waste_collection/waste_collection.dart';
import 'package:diakron_collectors/routing/routes.dart';
import 'package:diakron_collectors/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_collectors/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_collectors/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_collectors/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_collectors/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_collectors/ui/auth/reset_password/widgets/reset_password_screen.dart';
import 'package:diakron_collectors/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_collectors/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_collectors/ui/collections/list/view_models/collections_view_model.dart';
import 'package:diakron_collectors/ui/collections/list/widgets/collection_detail_screen.dart';
import 'package:diakron_collectors/ui/collections/list/widgets/collections_screen.dart';
import 'package:diakron_collectors/ui/collections/qr_collection/view_models/qr_collection_view_model.dart';
import 'package:diakron_collectors/ui/collections/qr_collection/widgets/qr_collection_screen.dart';
import 'package:diakron_collectors/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_collectors/ui/home/widgets/home_screen.dart';
import 'package:diakron_collectors/ui/main/widgets/main_screen.dart';
import 'package:diakron_collectors/ui/map/view_models/map_viewmodel.dart';
import 'package:diakron_collectors/ui/map/widgets/map_screen.dart';
import 'package:diakron_collectors/ui/mp_linked/widgets/mp_linking_handler.dart';
import 'package:diakron_collectors/ui/profile/view_models/profile_view_model.dart';
import 'package:diakron_collectors/ui/profile/widgets/profile_screen.dart';
import 'package:diakron_collectors/ui/scanner/view_models/scanner_viewmodel.dart';
import 'package:diakron_collectors/ui/scanner/widgets/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true, // TESTING
  refreshListenable: authRepository,
  redirect: _redirect,

  routes: [
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
                    locationService: context.read<LocationService>(),
                    collectorRepository: context.read<CollectorRepository>(),
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
                  collectorRespository: context.read<CollectorRepository>(),
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
            GoRoute(
              path: ':id', // This matches the ${collection.id}
              builder: (context, state) {
                final String idString = state.pathParameters['id']!;
                // Extract the ID from the URL path
                final viewModel = QRCollectionViewModel(
                  collectorRepository: context.read<CollectorRepository>(),
                  idCollection: idString,
                );
                return QRCollectionScreen(viewModel: viewModel);
              },
            ),
          ],
        ),
        GoRoute(
          path: Routes.scanner,
          builder: (context, state) {
            final viewModel = ScannerViewModel(
              authRepository: context.read<AuthRepository>(),
              collectorRepository: context.read<CollectorRepository>(),
            );
            return ScannerScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.map,
          builder: (context, state) {
            final viewModel = MapViewModel(
              mapRepository: MapRepositoryImpl(),
              collectorRepository: context.read<CollectorRepository>(),
            );
            return MapScreen(viewModel: viewModel);
          },
        ),

        GoRoute(
          path: Routes.profile,
          builder: (context, state) {
            final shouldRefresh = state.uri.queryParameters['refresh'] == 'true';
            final viewModel = ProfileViewModel(
              authRepository: context.read<AuthRepository>(),
              collectorRepository: context.read<CollectorRepository>(),
            );
            return ProfileScreen(viewModel: viewModel, refresh: shouldRefresh,);
          },
        ),
      ],
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

    //------------------------Mercado Pago Deep Links---------------
    GoRoute(
      path: '/success-linking', // GoRouter asocia el host del deep link al path
      builder: (context, state) {
        return const MpLinkingHandler();
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
