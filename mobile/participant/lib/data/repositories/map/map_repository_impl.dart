import 'package:diakron_participant/models/location/location_model.dart';
import 'map_repository.dart';

class MapRepositoryImpl implements MapRepository {
  @override
  Future<List<LocationModel>> getLocations() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      LocationModel(
        id: "seg1",
        address: "C. Nueva Escocia 1885, Providencia 5a Secc., 44638 Guadalajara, Jal.",
        stats: {'ME': 80, 'PL': 77, 'PA': 33, 'VI': 93},
        isConnected: true,
        lat: 20.671956,
        lng: -103.348821,
      ),
      LocationModel(
        id: "seg2",
        address: "C. Marcelino Dávalos 515, Jardines Alcalde, 44298 Guadalajara, Jal.",
        stats: {'ME': 80, 'PL': 77, 'PA': 33, 'VI': 93},
        isConnected: false,
        lat: 20.678402,
        lng: -103.346659,
      ),
      LocationModel(
        id: "seg3",
        address: "C. Nueva Escocia 1885, Providencia 5a Secc., 44638 Guadalajara, Jal.",
        stats: {'ME': 80, 'PL': 77, 'PA': 33, 'VI': 93},
        isConnected: false,
        lat: 20.675293669558908,
        lng: -103.34940147571169,
      ),
      LocationModel(
        id: "ca1",
        address: "Av. Chapultepec Norte 15. Col Americana",
        isConnected: false,
        lat: 20.6765238942309,
        lng: -103.36903498781554,
        avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
      ),
      LocationModel(
        id: "ca2",
        address: "Benjamín Romero 95, Vallarta, 44690 Guadalajara, Jal.",
        isConnected: false,
        lat: 20.670254981023405,
        lng: -103.3864857559351,
        avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
      ),
      LocationModel(
        id: "ca3",
        address: "Av. Chapultepec Norte 15. Col Americana",
        isConnected: true,
        lat: 20.676565706769814,
        lng: -103.34496815784952,
        avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
      ),
      LocationModel(
        id: "ca4",
        address: "Av. Alcalde 21B",
        isConnected: false,
        lat: 20.678046780557704,
        lng: -103.34761666332987,
        avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
      ),
      LocationModel(
        id: "ca4",
        address: "Av. Alcalde 21B",
        isConnected: true,
        lat: 20.678046780557704,
        lng: -103.34761666332987,
        avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
      ),
      LocationModel(
        id: "ca4",
        address: "Av. Alcalde 21B",
        isConnected: true,
        lat: 20.678046780557704,
        lng: -103.34761666332987,
        avatarUrl: 'https://pbs.twimg.com/profile_images/911823928259092480/XP3kMA6y_400x400.jpg',
      ),

    ];
  }
}