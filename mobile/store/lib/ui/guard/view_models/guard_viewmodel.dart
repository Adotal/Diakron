import 'package:diakron_stores/data/repositories/auth/auth_repository.dart';
import 'package:diakron_stores/data/repositories/user/store_repository.dart';
import 'package:diakron_stores/models/core/validation_status/validation_status.dart';
import 'package:diakron_stores/models/users/store.dart';
import 'package:diakron_stores/routing/routes.dart';
import 'package:diakron_stores/utils/command.dart';
import 'package:diakron_stores/utils/result.dart';
import 'package:flutter/material.dart';

class GuardViewModel extends ChangeNotifier {
  GuardViewModel({
    required AuthRepository authRepository,
    required StoreRepository storeRepository,
  }) : _storeRepository = storeRepository {
    // Initialize the command
    checkStatusCommand = Command0(_checkStatus);
  }
  final StoreRepository _storeRepository;

  late Command0 checkStatusCommand;

  Future<Result<void>> _checkStatus() async {
    // Following Compass: Repository is "dumb", we pass the ID from Auth
    final result = await _storeRepository.getStore(forceRefresh: true);

    if (result is Failure<Store>) {
      return Result.error(result.error);
    }

    return Result.ok(null);
  }

  // Helper to determine the route once the command succeeds
  Future<String> getTargetRoute() async {
    final store = await _storeRepository.getStore();
    switch (store) {
      case Success<Store>():
        switch (store.value.validationStatus) {
          case ValidationStatus.uploading:
            return Routes.uploadData;
          case ValidationStatus.pending:
            return Routes.waitingApproval;
          case ValidationStatus.approved:
            return Routes.home;
          case ValidationStatus.denied:
            return Routes.login; // Or a dedicated Denied route if you have one
        }
      case Failure<Store>():
    }
    return '';
  }
}
