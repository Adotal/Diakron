import 'package:diakron_admin/data/repositories/users/participant_repository.dart';
import 'package:diakron_admin/models/users/participant/participant.dart';
import 'package:diakron_admin/utils/command.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ParticipantsViewModel extends ChangeNotifier {
  ParticipantsViewModel({required ParticipantRepository participantRepository})
    : _participantRepository = participantRepository {
    load = Command0(_load);
    // updateCCenter  = Command1(_deleteBooking);
    // deleteCCenter = Command1(_deleteBooking);
  }

  final ParticipantRepository _participantRepository;

  List<Participant> _allParticipants = [];
  List<Participant> _filteredParticipants = [];
  List<Participant> get participants => _filteredParticipants;

  late Command0 load;
  final Logger _logger = Logger();
  String _searchQuery = '';

  Future<Result> _load() async {
    try {
      // Fetch all CollectionCenters
      final result = await _participantRepository.fetchParticipants();
      ();

      switch (result) {
        case Success<List<Participant>>():
          _allParticipants = result.value;
          _applyFilters();
        case Failure<List<Participant>>():
          _logger.w('Failed to load Participants ${result.error}');
          return result;
      }
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _applyFilters() {
    // Apply Text Search (by title)
    var temp = _allParticipants.where((c) {
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

    _filteredParticipants = temp;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }
}
