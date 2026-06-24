import 'package:diakron_collection_center/data/repositories/auth/auth_repository.dart';
import 'package:diakron_collection_center/data/repositories/user/ccenter_repository.dart';
import 'package:diakron_collection_center/models/core/validation_status/validation_status.dart';
import 'package:diakron_collection_center/models/users/collection_center.dart';
import 'package:diakron_collection_center/routing/routes.dart';
import 'package:diakron_collection_center/utils/command.dart';
import 'package:diakron_collection_center/utils/result.dart';
import 'package:flutter/material.dart';

class GuardViewModel extends ChangeNotifier {
  GuardViewModel({
    required AuthRepository authRepository,
    required CCenterRepository userRepository,
  }) : _userRepository = userRepository {
    // Initialize the command
    checkStatusCommand = Command0(_checkStatus);
  }
  final CCenterRepository _userRepository;

  late Command0 checkStatusCommand;

  Future<Result<void>> _checkStatus() async {
    // Following Compass: Repository is "dumb", we pass the ID from Auth
    final result = await _userRepository.getCollectionCenter(forceRefresh: true);

    if (result is Failure<CollectionCenter>) {
      return Result.error(result.error);
    }

    return Result.ok(null);
  }

  // Helper to determine the route once the command succeeds
  Future<String> getTargetRoute() async {
    final collectionCenter = await _userRepository.getCollectionCenter();
    switch (collectionCenter) {
      case Success<CollectionCenter>():
        switch (collectionCenter.value.validationStatus) {
          case ValidationStatus.uploading:
            return Routes.uploadData;
          case ValidationStatus.pending:
            return Routes.waitingApproval;
          case ValidationStatus.approved:
            return Routes.home;
          case ValidationStatus.denied:
            return Routes.login; // Or a dedicated Denied route if you have one
        }
      case Failure<CollectionCenter>():
    }
    return '';
  }
}
