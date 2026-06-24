import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/models/incentive/incentive.dart';
import 'package:diakron_admin/models/users/admin/admin.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';

class AdminRepository {
  AdminRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  final DatabaseService _databaseService;
  final _logger = Logger();
  Admin? _cachedAdmin;
  Admin get cachedAdmin => _cachedAdmin!;

  Future<Result<Admin>> getAdmin({bool forceRefresh = false}) async {
    if (_cachedAdmin != null && !forceRefresh) {
      _logger.i('Returned cached ${_cachedAdmin.toString()}');
      return Future.value(Result.ok(_cachedAdmin!));
    }
    final result = await _databaseService.getAdmin();
    switch (result) {
      case Success<Map<String, dynamic>>():
        _cachedAdmin = Admin.fromJson(result.value);

        _logger.i('Returned refreshed ${_cachedAdmin.toString()}');
        return Result.ok(_cachedAdmin!);
      case Failure<Map<String, dynamic>>():
        return Result.error(result.error);
    }
  }

  void clearCache() {
    _cachedAdmin = null;
  }

  Future<Result<void>> updateAdmin({
    required String adminId,
    required Map<String, dynamic> dataToUpdate,
  }) async {
    final result = await _databaseService.updateData(
      table: 'users',
      map: dataToUpdate,
      id: adminId,
    );

    return result;
  }

  Future<Result<void>> updateAdminInfo(Admin editedAdmin) async {
    try {
      return await _databaseService.updateFullUser(editedAdmin);
    } on Exception catch (error) {
      _logger.e(error);
      return Result.error(error);
    }
  }

  Future<Result<void>> deleteUserById({required String id}) async {
    return await _databaseService.deleteUserById(id: id);
  }

  Future<Result<Admin>> getAdminById(String id) async {
    // Retrieves from a VIEW
    final result = await _databaseService.getUserById(
      table: 'full_admins',
      id: id,
    );

    switch (result) {
      case Success<Map<String, dynamic>>():
        final center = Admin.fromJson(result.value);
        return Result.ok(center);
      case Failure<Map<String, dynamic>>():
        _logger.e('Error: ${result.error}');
        return Result.error(result.error);
    }
  }

  Future<Result<void>> deleteAdmin({required String id}) async {
    try {
      return await _databaseService.deleteUserById(id: id);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> changeActiveStatus(bool isActive, String id) async {
    final result = await _databaseService.updateData(
      table: 'users',
      map: <String, dynamic>{"is_active": isActive},
      id: id,
    );
    return result;
  }

    Future<Result<List<Admin>>> fetchAdmins() async {
    try {
      final result = await _databaseService.fetchColumnsTable(
        table: 'full_admins',
        columns: '''id, user_name, is_superadmin, is_active''',
      );
      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Admin> centers = (result.value as List)
              .map((item) => Admin.fromJson(item as Map<String, dynamic>))
              .toList();

          return Result.ok(centers);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

    Future<Result<List<Incentive>>> fetchIncentives() async {
    try {
      final result = await _databaseService.fetchTable(
        table: 'full_incentives',     
      );

      switch (result) {
        case Success<List<Map<String, dynamic>>>():
          List<Incentive> wasteCollections = (result.value as List)
              .map((json) => Incentive.fromJson(json))
              .toList();

          return Result.ok(wasteCollections);

        case Failure<List<Map<String, dynamic>>>():
          return Result.error(result.error);
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }
}
