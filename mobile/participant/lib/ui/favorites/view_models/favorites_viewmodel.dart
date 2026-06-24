import 'package:diakron_participant/data/repositories/user/participant_repository.dart';
import 'package:diakron_participant/models/coupon/coupon.dart';
import 'package:diakron_participant/models/users/participant.dart';
import 'package:diakron_participant/utils/command.dart';
import 'package:diakron_participant/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FavoritesViewmodel extends ChangeNotifier {
  FavoritesViewmodel({required ParticipantRepository participantRepository})
    : _participantRepository = participantRepository {

    load = Command0(_load);
    }

  final ParticipantRepository _participantRepository;

    late Command0 load;
  int _points = 0;
  String? _participantId;
  int get points => _points;

    // Two list, one for source of truth and second for search and filters
  List<Coupon> _allCoupons = [];   
  List<Coupon> _filteredCoupons = [];

  // The UI should ONLY read from _filteredCoupons
  List<Coupon> get coupons => _filteredCoupons;

  // Checks if there are absolutely zero coupons in the system 
  String _searchQuery = '';

 bool get isSearching => _searchQuery.isNotEmpty;

  final _logger = Logger();
 
 Future<Result<void>> _load() async {
    try {
      // First fetch participant user (for number of points)
      final participantResult = await _participantRepository.getParticipant();
      switch (participantResult) {
        case Success<Participant>():
          _points = participantResult.value.points;
          _participantId = participantResult.value.id;
        case Failure<Participant>():
          return Result.error(participantResult.error);
      }

   

      // Fetch list of coupons
      final result = await _participantRepository.fetchFavoriteCoupons(participantId:  _participantId!);
      // final result = await _participantRepository.fetchCoupons();

      switch (result) {
        case Success<List<Coupon>>():
          _allCoupons = result.value;
          _applyFilters();
          // Removed map((e) => e.toJson()).toList()
          // Serializing a whole list to JSON purely for a debug log is a massive CPU waste.
          _logger.d('Loaded ${_allCoupons.length} Coupons');

        case Failure<List<Coupon>>():
          _logger.w('Failed to load Coupons ${result.error}');
      }


      return Result.ok(null);
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      notifyListeners();
    }
  }


  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    
  }
  
  void _applyFilters() {
    // 1. Apply Text Search (by title)
    var temp = _allCoupons.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    _filteredCoupons = temp;
    notifyListeners();
  }
    // Function to clean everything
  void clearFilters() {
    _searchQuery = "";
    _applyFilters();
  }
}
