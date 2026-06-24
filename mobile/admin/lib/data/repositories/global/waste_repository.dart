import 'package:diakron_admin/data/services/database_service.dart';
import 'package:diakron_admin/models/core/waste_type/waste_type.dart';
import 'package:diakron_admin/utils/result.dart';
import 'package:logger/logger.dart';

class WasteRepository {
  WasteRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  Future<void> init() async {
    await getWasteTypesTable();
  }

  final DatabaseService _databaseService;
  final _logger = Logger();

  // WasteTypes
  List<WasteType> _wasteTypesGlobal = [];
  List<WasteType> get wasteTypesGlobal => _wasteTypesGlobal;

  // Helper method to resolve names
  String getWasteTypeName(int id) =>
      _wasteTypesGlobal[id].wasteType ?? "Unknown waste type";

  // Helper to get a name by ID instantly without a DB call
  // String getNameById(int id) {
  //   return _cachedTypes.firstWhere((t) => t.id == id, orElse: () => const WasteType(id: 0, name: 'Unknown')).name;
  // }

  Future<void> getWasteTypesTable() async {
    final result = await _databaseService.fetchAllWasteTypes();
    switch (result) {
      case Success<List<Map<String, dynamic>>>():
        _wasteTypesGlobal = result.value
            .map((json) => WasteType.fromJson(json))
            .toList();
        _logger.i(_wasteTypesGlobal.toString());
      case Failure<List<Map<String, dynamic>>>():
        _logger.e('Error fetching waste types $result');
    }
  }
}
