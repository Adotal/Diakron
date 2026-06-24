import 'package:diakron_collectors/data/repositories/map/map_repository.dart';
import 'package:diakron_collectors/data/repositories/user/collector_repository.dart';
import 'package:diakron_collectors/models/location/location_model.dart';
import 'package:diakron_collectors/models/segregator/segregator.dart';
import 'package:diakron_collectors/utils/command.dart';
import 'package:diakron_collectors/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel({
    required MapRepository mapRepository,
    required CollectorRepository collectorRepository,
  }) : _mapRepository = mapRepository,
       _collectorRepository = collectorRepository {
    load = Command0<void>(_load)..execute();
  }

  final CollectorRepository _collectorRepository;
  final MapRepository _mapRepository;
  bool _isMapSelected = true; // Mapa / Lista
  bool get isMapSelected => _isMapSelected;

  bool _showSegregadores = true; // Segregadores / Centros de Acopio
  bool get showSegregadores => _showSegregadores;

  String _searchText = "";
  String get searchText => _searchText;

  List<LocationModel> _allLocations = [];
  List<LocationModel> _filteredLocations = [];
  List<LocationModel> get filteredLocations => _filteredLocations;
  final _logger = Logger();

  List<Segregator> _segregators = [];
  List<Segregator> _filteredSegregators = [];
  List<Segregator> get segregators => _filteredSegregators;

  late Command0<void> load;

  Future<Result<void>> _load() async {
    try {
      // Fetch locations and filling levels
      final result = await _collectorRepository.fetchSegregators();
      switch (result) {
        
        case Success<List<Segregator>>():
          _segregators = result.value;

          // TESTING, PENDING ADD FILTERS
          _filteredSegregators = _segregators;

          _logger.i(_segregators);

        case Failure<List<Segregator>>():
          _logger.e(result.error);
          return result;
      }

      _allLocations = await _mapRepository.getLocations();
      _applyFilters();
      return Result.ok(null);
    } finally {
      notifyListeners();
    }
  }

  void toggleViewMode() {
    _isMapSelected = !_isMapSelected;
    notifyListeners();
  }

  void toggleLocationType() {
    _showSegregadores = !_showSegregadores;
    _applyFilters();
    notifyListeners();
  }

  void updateSearchText(String text) {
    _searchText = text;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredLocations = _allLocations.where((loc) {
      final isTypeMatch = _showSegregadores
          ? loc.id.startsWith("seg")
          : loc.id.startsWith("ca");

      final isTextMatch =
          _searchText.isEmpty ||
          loc.address.toLowerCase().contains(_searchText.toLowerCase());

      return isTypeMatch && isTextMatch;
    }).toList();

    notifyListeners();
  }
}