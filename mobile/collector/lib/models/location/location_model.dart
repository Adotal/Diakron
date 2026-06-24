class LocationModel {
  final String id;
  final String address;
  final Map<String, int>? stats;
  final bool isConnected;
  final double lat;
  final double lng;
  final String? avatarUrl;

  LocationModel({
    required this.id,
    required this.address,
    this.stats,
    required this.isConnected,
    required this.lat,
    required this.lng,
    this.avatarUrl,
  });
}