import 'package:diakron_admin/data/repositories/users/admin_repository.dart';
import 'package:diakron_admin/models/core/taxpayer_type/taxpayer_type.dart';
import 'package:diakron_admin/models/users/admin/admin.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';

class AdminDetailsViewModel extends ChangeNotifier {
  AdminDetailsViewModel({
    required AdminRepository adminRepository,
    required this.adminId,
  }) : _adminRepository = adminRepository {
    load = Command0(_load)..execute();
    deleteAdmin = Command0(_deleteAdmin);
    updateAdmin = Command0(_updateAdmin);
    changeValidationStatus = Command1(_changeActiveStatus);
  }

  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    if (_isEditing) {
      editedAdmin = admin;
    }
    notifyListeners();
  }

  TaxpayerType? taxpayerType;

  final AdminRepository _adminRepository;
  final String adminId;

  late Command0 load;
  late Command0 deleteAdmin;
  late Command0 updateAdmin;
  late Command1<void, bool> changeValidationStatus;
  Admin? admin;
  Admin? editedAdmin;

  final _logger = Logger();

  Future<Result<void>> _changeActiveStatus(bool isActive) async {
    _logger.i('New $isActive\n $adminId');
    try {
      final result = await _adminRepository.changeActiveStatus(
        isActive,
        adminId,
      );

      switch (result) {
        case Success<void>():
          _logger.i('Changed status to $isActive');
        case Failure<void>():
          _logger.e('ERROR CHANGING STATUS ${result.error}');
      }

      // Reload
      load.execute();
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _updateAdmin() async {
    try {
      final result = await _adminRepository.updateAdminInfo(editedAdmin!);

      switch (result) {
        case Success<void>():
          _logger.i('Updated Admin successfully');
        case Failure<void>():
          _logger.e('ERROR UPDATING Admin');
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  Future<Result> _load() async {
    try {
      // Fetch fresh data for this specific admin
      final result = await _adminRepository.getAdminById(adminId);

      switch (result) {
        case Success<Admin>():
          admin = result.value;
          _logger.d(admin);
        case Failure<Admin>():
          return result;
      }

      return result;
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteAdmin() async {
    try {
      final result = await _adminRepository.deleteAdmin(id: adminId);
      switch (result) {
        case Success<void>():
          _logger.i('Successfully deleted admin');
        case Failure<void>():
          _logger.e('Error deleted admin');
      }

      return result;
    } finally {
      notifyListeners();
    }
  }
}
