import '../../../models/location/location_model.dart';
abstract class MapRepository {
  Future<List<LocationModel>> getLocations();
}
