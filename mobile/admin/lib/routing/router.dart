// Routes manager
import 'package:diakron_admin/data/repositories/auth/auth_repository.dart';
import 'package:diakron_admin/data/repositories/global/waste_repository.dart';
import 'package:diakron_admin/data/repositories/users/admin_repository.dart';
import 'package:diakron_admin/data/repositories/users/collection_center_repository.dart';
import 'package:diakron_admin/data/repositories/map/map_repository_impl.dart';
import 'package:diakron_admin/data/repositories/users/collector_repository.dart';
import 'package:diakron_admin/data/repositories/users/participant_repository.dart';
import 'package:diakron_admin/data/repositories/users/store_repository.dart';
import 'package:diakron_admin/models/incentive/incentive.dart';
import 'package:diakron_admin/routing/routes.dart';
import 'package:diakron_admin/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:diakron_admin/ui/auth/forgot_password/widgets/forgot_password_screen.dart';
import 'package:diakron_admin/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:diakron_admin/ui/auth/login/widgets/login_screen.dart';
import 'package:diakron_admin/ui/auth/reset_password/view_models/reset_password_viewmodel.dart';
import 'package:diakron_admin/ui/auth/reset_password/widgets/reset_password_screen.dart';
import 'package:diakron_admin/ui/auth/sigunp/view_models/signup_viewmodel.dart';
import 'package:diakron_admin/ui/auth/sigunp/widgets/signup_screen.dart';
import 'package:diakron_admin/ui/incentives/view_models/incentives_view_model.dart';
import 'package:diakron_admin/ui/incentives/widgets/incentive_detail_screen.dart';
import 'package:diakron_admin/ui/incentives/widgets/incentives_screen.dart';
import 'package:diakron_admin/ui/users_menu/admins/details/view_models/admin_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/admins/details/widgets/admin_details_screen.dart';
import 'package:diakron_admin/ui/users_menu/admins/table/view_models/admins_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/admins/table/widgets/admins_screen.dart';
import 'package:diakron_admin/ui/users_menu/collection_centers/details/view_models/collection_center_details_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/collection_centers/details/widgets/collection_center_details_screen.dart';
import 'package:diakron_admin/ui/users_menu/collection_centers/table/view_models/collection_centers_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/collection_centers/table/widgets/collection_centers_screen.dart';
import 'package:diakron_admin/ui/home/view_models/home_viewmodel.dart';
import 'package:diakron_admin/ui/home/widgets/home_screen.dart';
import 'package:diakron_admin/ui/main/widgets/main_screen.dart';
import 'package:diakron_admin/ui/map/view_models/map_viewmodel.dart';
import 'package:diakron_admin/ui/map/widgets/map_screen.dart';
import 'package:diakron_admin/ui/profile/view_models/profile_view_model.dart';
import 'package:diakron_admin/ui/profile/widgets/profile_screen.dart';
import 'package:diakron_admin/ui/users_menu/collectors/details/view_models/collector_details_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/collectors/details/widgets/collectors_details_screen.dart';
import 'package:diakron_admin/ui/users_menu/collectors/table/view_models/collectors_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/collectors/table/widgets/collectors_screen.dart';
import 'package:diakron_admin/ui/users_menu/participants/details/view_models/participant_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/participants/details/widgets/participant_details_screen.dart';
import 'package:diakron_admin/ui/users_menu/participants/table/view_models/participants_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/participants/table/widgets/participants_screen.dart';
import 'package:diakron_admin/ui/users_menu/stores/details/view_models/store_details_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/stores/details/widgets/store_details_screen.dart';
import 'package:diakron_admin/ui/users_menu/stores/table/view_models/stores_viewmodel.dart';
import 'package:diakron_admin/ui/users_menu/stores/table/widgets/stores_screen.dart';
import 'package:diakron_admin/ui/users_menu/widgets/users_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.home,
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
                authRepository: context.read<AuthRepository>(),
                adminRepository: context.read<AdminRepository>(),
              ),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // Use a simple fade so the pre-charged home page appears smoothly
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        GoRoute(
          path: Routes.map,
          builder: (context, state) {
            return MapScreen(
              viewModel: MapViewModel(
                mapRepository: MapRepositoryImpl(),
                collectorRepository: context.read<CollectorRepository>(),
              ),
            );
          },
        ),

        GoRoute(
          path: Routes.users,
          builder: (context, state) => const UsersMenuScreen(),
          routes: [
            GoRoute(
              path: Routes.adminsRelative, // /users/admins
              builder: (context, state) {
                final viewModel = AdminsViewModel(
                  adminRepository: context.read<AdminRepository>(),
                );
                return AdminsScreen(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  path: ':id', // This matches the ${center.id} in your push
                  builder: (context, state) {
                    // Extract the ID from the URL path
                    final String idString = state.pathParameters['id']!;
                    final String adminId = idString;
                    final viewModel = AdminDetailsViewModel(
                      adminRepository: context.read<AdminRepository>(),
                      adminId: adminId,
                    );

                    return AdminDetailsScreen(viewModel: viewModel);
                  },
                ),
              ],
              // builder: (context, state) => const AdminUserScreen(),
            ),

            GoRoute(
              path: Routes.collectionCentersRelative,
              builder: (context, state) {
                final viewModel = CollectionCentersViewmodel(
                  ccenterRepository: context.read<CollectionCenterRepository>(),
                  wasteRepository: context.read<WasteRepository>(),
                );
                return CollectionCentersScreen(viewModel: viewModel);
              },
              // Details screen
              routes: [
                GoRoute(
                  path: ':id', // This matches the ${center.id} in your push
                  builder: (context, state) {
                    // Extract the ID from the URL path
                    final String idString = state.pathParameters['id']!;
                    final String centerId = idString;
                    final CollectionCenterDetailsViewModel viewModel =
                        CollectionCenterDetailsViewModel(
                          repository: context
                              .read<CollectionCenterRepository>(),
                          wasteRepository: context.read<WasteRepository>(),
                          centerId: centerId,
                        );

                    return CollectionCenterDetailsScreen(viewModel: viewModel);
                  },
                ),
              ],
            ),

            GoRoute(
              path: Routes.participantsRelative, // Full path: /users/customer
              builder: (context, state) {
                final viewModel = ParticipantsViewModel(
                  participantRepository: context.read<ParticipantRepository>(),
                );
                return ParticipantsScreen(viewModel: viewModel);
              },
              // Details screen
              routes: [
                GoRoute(
                  path: ':id', // This matches the ${center.id} in your push
                  builder: (context, state) {
                    // Extract the ID from the URL path
                    final String idString = state.pathParameters['id']!;
                    final String participantId = idString;
                    final viewModel = ParticipantDetailsViewModel(
                      participantId: participantId,
                      participantsRepository: context
                          .read<ParticipantRepository>(),
                    );

                    return ParticipantDetailsScreen(viewModel: viewModel);
                  },
                ),
              ],
              // builder: (context, state) => const CustomerUserScreen(),
            ),
            GoRoute(
              path: Routes.storesRelative, // Full path: /users/stores
              builder: (context, state) {
                final viewModel = StoresViewModel(
                  storeRepository: context.read<StoreRepository>(),
                );
                return StoresScreen(viewModel: viewModel);
              },
              // Details screen
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    // Extract the ID from the URL path

                    final totalPoints = state.extra;

                    if (totalPoints is int) {
                      final String idString = state.pathParameters['id']!;
                      final String storeId = idString;
                      final viewModel = StoreDetailsViewModel(
                        storeRepository: context.read<StoreRepository>(),
                        storeId: storeId,
                        totalPoints: totalPoints,
                      );

                      return StoreDetailsScreen(viewModel: viewModel);
                    }
                    return const Scaffold(
                      body: Center(
                        child: Text("Error en total de puntos"),
                      ),
                    );
                  },
                ),
              ],
              // builder: (context, state) => const CustomerUserScreen(),
            ),
            GoRoute(
              path: Routes.collectorsRelative, // Full path: /users/customer
              builder: (context, state) {
                final viewModel = CollectorsViewModel(
                  collectorRepository: context.read<CollectorRepository>(),
                );
                return CollectorsScreen(viewModel: viewModel);
              },
              // Details screen
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    // Extract the ID from the URL path
                    final String idString = state.pathParameters['id']!;
                    final String collectorId = idString;
                    final viewModel = CollectorDetailsViewModel(
                      collectorId: collectorId,
                      collectorsRepository: context.read<CollectorRepository>(),
                    );

                    return CollectorDetailsScreen(viewModel: viewModel);
                  },
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: Routes.incentives,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: ChangeNotifierProvider<IncentivesViewModel>(
                create: (context) => IncentivesViewModel(
                  adminRepository: context.read<AdminRepository>(),
                ),
                child: Builder(
                  builder: (context) {
                    final viewModel = context.read<IncentivesViewModel>();
                    return IncentivesScreen(viewModel: viewModel);
                  },
                ),
              ),
            );
          },

          routes: [
            GoRoute(
              path: Routes.detailsRelative,
              builder: (context, state) {
                final incentive = state.extra;

                if (incentive is Incentive) {
                  return IncentiveDetailScreen(incentive: incentive);
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
          path: Routes.settings,
          builder: (context, state) {
            final viewModel = ProfileViewModel(
              adminRepository: context.read<AdminRepository>(),
              authRepository: context.read<AuthRepository>(),
            );
            return ProfileScreen(viewModel: viewModel);
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

  // If we are currently logging in and querying the 'users' table, do nothing.
  if (authRepo.isVerifyingAuth) {
    return null;
  }
  // Logged in in login go Home
  if (loggedIn && isAtLogin) {
    return Routes.home;
  }

  return null;
}
