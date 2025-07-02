// class LocationPoint {
//   final double latitude;
//   final double longitude;
//   final String address;

//   LocationPoint({
//     required this.latitude,
//     required this.longitude,
//     required this.address,
//   });

//   @override
//   String toString() {
//     return 'LocationPoint(lat: $latitude, lng: $longitude, address: $address)';
//   }
// }



class LocationPoint {
  final double latitude;
  final double longitude;
  final String address;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  String toString() {
    return 'LocationPoint(lat: $latitude, lng: $longitude, address: $address)';
  }
}

class DummyLocation {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String category;
  final bool isOnRoute;
  final double? distanceFromRoute;

  DummyLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.category,
    this.isOnRoute = false,
    this.distanceFromRoute,
  });

  LocationPoint toLocationPoint() {
    return LocationPoint(
      latitude: latitude,
      longitude: longitude,
      address: name,
    );
  }
}