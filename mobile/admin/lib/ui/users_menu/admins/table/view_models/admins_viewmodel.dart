import 'package:diakron_admin/data/repositories/users/admin_repository.dart';
import 'package:diakron_admin/models/users/admin/admin.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AdminsViewModel extends ChangeNotifier {
  AdminsViewModel({required AdminRepository adminRepository})
    : _adminRepository = adminRepository {
    load = Command0(_load);
    // updateCCenter  = Command1(_deleteBooking);
    // deleteCCenter = Command1(_deleteBooking);
  }

  final AdminRepository _adminRepository;

  List<Admin> _allAdmins = [];
  List<Admin> _filteredAdmins = [];
  List<Admin> get admins => _filteredAdmins;

  late Command0 load;
  final Logger _logger = Logger();
  String _searchQuery = '';

  Future<Result> _load() async {
    try {
      // Fetch all CollectionCenters
      final result = await _adminRepository.fetchAdmins();
      ();

      switch (result) {
        case Success<List<Admin>>():
          _allAdmins = result.value;
          _applyFilters();
        case Failure<List<Admin>>():
          _logger.w('Failed to load Admins ${result.error}');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allAdmins.where((c) {
      // Filtro de Búsqueda
      if (_searchQuery.isNotEmpty) {
        if (!c.userName!.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        )) {
          return false;
        }
      }
      return true;
    }).toList();

    // Apply Sort
    // switch (_currentSort) {
    //   case CouponSort.priceAsc:
    //     temp.sort((a, b) => a.pricePoints.compareTo(b.pricePoints));
    //     break;
    //   case CouponSort.priceDesc:
    //     temp.sort((a, b) => b.pricePoints.compareTo(a.pricePoints));
    //     break;
    //   case CouponSort.dateAsc:
    //     temp.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    //     break;
    //   case CouponSort.dateDesc:
    //     temp.sort((a, b) => b.expirationDate.compareTo(a.expirationDate));
    //     break;
    //   case CouponSort.redeemAsc:
    //     temp.sort((a, b) => b.redeemTimes.compareTo(a.redeemTimes));
    //     break;
    //   case CouponSort.redeemDesc:
    //     temp.sort((a, b) => a.redeemTimes.compareTo(b.redeemTimes));
    //     break;
    //   case CouponSort.none:
    //   default:
    //     // Optional: Default sort (e.g., newest first based on ID or creation date)
    //     break;
    // }

    _filteredAdmins = temp;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
}
