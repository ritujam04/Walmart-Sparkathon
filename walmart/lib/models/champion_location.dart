class ChampionLocation {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String communityArea;
  final bool isOnRoute;
  final double distanceFromRoute;
  final int flag;

  ChampionLocation({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.communityArea,
    this.isOnRoute = false,
    this.distanceFromRoute = 0.0,
    this.flag = 0,
  });

  // /// Convert from Supabase (Map<String, dynamic>) to ChampionLocation
  // factory ChampionLocation.fromMap(Map<String, dynamic> map) {
  //    print("🟡 Raw champion map: $map"); // Debug print
  //    print("🟢 community: ${map['community']}");
  //   return ChampionLocation(
  //     id: map['id'],
  //     latitude: map['latitude'],
  //     longitude: map['longitude'],
  //     name: map['name'],
  //     communityArea: map['community']?['area'] ?? 'unknown',
  //     // communityArea: map['community']['area'] ?? 'unknown',
  //     flag: map['flag'] ?? 0,
  //   );
  // }

factory ChampionLocation.fromMap(Map<String, dynamic> map) {
  print("🟡 Raw champion map: $map"); // Debug print
  print("🟢 community: ${map['community']}");
  return ChampionLocation(
    id: map['id'],
    latitude: map['latitude'],
    longitude: map['longitude'],
    name: map['name'],
    communityArea: map['community']?['area'] ?? 'unknown',
    distanceFromRoute: (map['distanceFromRoute'] ?? 0.0).toDouble(), // ✅ Fix
    flag: map['flag'] ?? 0,
  );
}
  /// Convert ChampionLocation back to map if needed
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'community': {'area': communityArea},
      'isOnRoute': isOnRoute,
      'distanceFromRoute': distanceFromRoute,
      'flag': flag,
    };
  }
}
