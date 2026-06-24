import 'package:diakron_collectors/models/location/location_model.dart';
abstract class MapRepository {
  Future<List<LocationModel>> getLocations();
}
