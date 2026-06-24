import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/ui/auth/logout/view_models/logout_viewmodel.dart';
import 'package:diakron_collection_center/ui/auth/logout/widgets/logout_button.dart';
import 'package:diakron_collection_center/ui/core/themes/dimens.dart';
import 'package:diakron_collection_center/ui/upload_files/view_models/upload_files_viewmodel.dart';
import 'package:diakron_collection_center/ui/core/themes/app_strings.dart';
import 'package:diakron_collection_center/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UploadFilesShell extends StatelessWidget {
  final Widget child;

  static const int totalPages = 4;

  const UploadFilesShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 1. Obtener la ubicación para la lógica de progreso y botones
    final String location = GoRouterState.of(context).matchedLocation;

    final vm = context.read<UploadFilesViewModel>();

    // Calcular progreso (33%, 66%, 100%)
    double progress = 0;
    if (location.endsWith('2')) progress = 0.33;
    if (location.endsWith('3')) progress = 0.66;
    if (location.startsWith(Routes.privacyPolicy)) progress = 0.95;

    return Scaffold(
      backgroundColor: AppColors.greenDiakron1,
      body: Column(
        children: [
          // SECCIÓN SUPERIOR
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4,
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: Dimens.paddingHorizontal,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.recycling,
                              color: Colors.white,
                              size: 30,
                            ),

                            SizedBox(width: 10),
                            Text(
                              AppStrings.appName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        LogoutButton(
                          viewModel: LogoutViewModel(
                            authRepository: context.read<AuthRepository>(),
                            userRepository: context.read<CCenterRepository>(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // BARRA DE PROGRESO (Debajo del Header)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(45.0)),
              ),
              child: context.watch<UploadFilesViewModel>().isProcessing
                  ? _LoadingView()
                  : Column(
                      children: [
                        // Contenido de la página (Step 1, 2 o 3)
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(45.0),
                            ),
                            child: child,
                          ),
                        ),

                        // SECCIÓN DE BOTONES (Fija en la parte inferior del área blanca)
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (!location.endsWith('1'))
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      37,
                                      79,
                                      13,
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (location == Routes.privacyPolicy) {
                                      context.go(Routes.uploadData3);
                                    } else if (location.endsWith('3')) {
                                      context.go(Routes.uploadData2);
                                    } else if (location.endsWith('2')) {
                                      context.go(Routes.uploadData);
                                    }
                                  },
                                  child: Text('Anterior'),
                                )
                              else
                                const SizedBox.shrink(),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.greenDiakron1,
                                  foregroundColor: Colors.white,
                                  disabledForegroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey,
                                ),
                                // Disabled if in last page and not accepted terms and conditions
                                onPressed:
                                    (location == Routes.privacyPolicy &&
                                        !vm.isAccepted)
                                    ? null
                                    : () async {
                                        // final vm = context
                                        // .read<UploadFilesViewModel>();
                                        if (location == Routes.privacyPolicy &&
                                            !vm.isAccepted) {
                                          null;
                                        }

                                        if (location.endsWith('1')) {
                                          if (vm.validateStep1()) {
                                            vm.timeErrorMsj = null;
                                            context.go(Routes.uploadData2);
                                          }
                                        } else if (location.endsWith('2')) {
                                          if (vm.validateStep2()) {
                                            context.go(Routes.uploadData3);
                                          }
                                        } else if (location.endsWith('3')) {
                                          if (vm.validateStep3()) {
                                            // Go Last page
                                            context.go(Routes.privacyPolicy);
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Por favor, sube todos los documentos",
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          if (vm.isAccepted) {
                                            // Upload all files
                                            await vm.completeRegistration
                                                .execute();
                                            context.go(Routes.guard);
                                          }
                                        }
                                      },
                                child: Text(
                                  location.endsWith(Routes.privacyPolicy)
                                      ? "Finalizar"
                                      : "Siguiente",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for the Loading View
class _LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final message = context.select<UploadFilesViewModel, String>(
      (vm) => vm.uploadMessage,
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.greenDiakron1),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
