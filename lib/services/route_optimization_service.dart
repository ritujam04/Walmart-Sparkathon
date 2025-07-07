// import 'dart:math';
// import 'package:latlong2/latlong.dart';
// import '../models/location_model.dart';

// class RouteOptimizationService {
//   // Dummy store locations - you can replace this with your actual store data
//   static List<DummyLocation> _dummyStores = [
//     DummyLocation(
//       id: 1,
//       latitude: 20.00803098429236,
//       longitude: 73.77656021855675,
//       name: "KTHM",
//       category: "loc-1",
//     ),
//     DummyLocation(
//       id: 2,
//       latitude: 20.007505980658056, 
//       longitude: 73.7961771071426,
//       name: "Kala Ram Mandir",
//       category: "loc-2",
//     ),
//     DummyLocation(
//       id: 3,
//       latitude: 19.990183423442613,
//       longitude: 73.79366374089598,
//       name: "Sahydari Hospitol",
//       category: "loc-3",
//     ),
//     DummyLocation(
//       id: 4,
//       latitude: 19.993156159774582, 
//       longitude: 73.76206350282321,
//       name: "City Center Mall",
//       category: "loc-4",
//     ),
//     DummyLocation(
//       id: 5,
//       latitude: 20.01658060849549, 
//       longitude: 73.79395831141943,
//       name: "Bhaktidham",
//       category: "loc-5",
//     ),
//     DummyLocation(
//       id: 6,
//       latitude: 19.979774523485347, 
//       longitude: 73.8083278648155,
//       name: "Vijay Mamta Cienma",
//       category: "loc-6",
//     ),
//     DummyLocation(
//       id: 7,
//       latitude: 20.01020713300111, 
//       longitude: 73.80820792145958,
//       name: "Adgaon Naka",
//       category: "loc-7",
//     ),
//     DummyLocation(
//       id: 8,
//       latitude: 20.074050045784297, 
//       longitude: 73.90421762100613,
//       name: "Dhava Mail",
//       category: "loc-8",
//     ), 
//     DummyLocation(
//       id: 9,
//       latitude: 20.013698177452643,
//       longitude: 73.82222920910871,
//       name: "K K Wagh",
//       category: "loc-9",
//     )
//   ];

//   // Find stores that are close to the route
//   static List<DummyLocation> findLocationsOnRoute(
//     LocationPoint start,
//     LocationPoint end,
//     List<LatLng> routePoints, {
//     double maxDistanceFromRoute = 2000, // 5km threshold
//   }) {
//     List<DummyLocation> locationsOnRoute = [];

//     for (DummyLocation store in _dummyStores) {
//       double minDistance = double.infinity;
      
//       // Check distance from store to each point on the route
//       for (LatLng routePoint in routePoints) {
//         double distance = _calculateDistance(
//           store.latitude,
//           store.longitude,
//           routePoint.latitude,
//           routePoint.longitude,
//         );
        
//         if (distance < minDistance) {
//           minDistance = distance;
//         }
//       }
      
//       // If store is within threshold distance from route, include it
//       if (minDistance <= maxDistanceFromRoute) {
//         locationsOnRoute.add(DummyLocation(
//           id: store.id,
//           latitude: store.latitude,
//           longitude: store.longitude,
//           name: store.name,
//           category: store.category,
//           isOnRoute: true,
//           distanceFromRoute: minDistance,
//         ));
//       }
//     }

//     return locationsOnRoute;
//   }

//   // Optimize waypoints order using nearest neighbor algorithm
//   static List<DummyLocation> optimizeWaypoints(
//     LocationPoint start,
//     List<DummyLocation> waypoints,
//     LocationPoint end,
//   ) {
//     if (waypoints.isEmpty) return [];

//     List<DummyLocation> optimized = [];
//     List<DummyLocation> remaining = List.from(waypoints);
//     LocationPoint currentLocation = start;

//     while (remaining.isNotEmpty) {
//       DummyLocation nearest = remaining.first;
//       double nearestDistance = _calculateDistance(
//         currentLocation.latitude,
//         currentLocation.longitude,
//         nearest.latitude,
//         nearest.longitude,
//       );

//       // Find the nearest unvisited waypoint
//       for (DummyLocation waypoint in remaining) {
//         double distance = _calculateDistance(
//           currentLocation.latitude,
//           currentLocation.longitude,
//           waypoint.latitude,
//           waypoint.longitude,
//         );
        
//         if (distance < nearestDistance) {
//           nearest = waypoint;
//           nearestDistance = distance;
//         }
//       }

//       optimized.add(nearest);
//       remaining.remove(nearest);
//       currentLocation = LocationPoint(
//         latitude: nearest.latitude,
//         longitude: nearest.longitude,
//         address: nearest.name,
//       );
//     }

//     return optimized;
//   }

//   // Check if the route is optimal (simple heuristic)
//   static bool isRouteOptimal(
//     LocationPoint start,
//     LocationPoint end,
//     List<DummyLocation> waypoints,
//   ) {
//     if (waypoints.isEmpty) return true;

//     // Calculate total distance with waypoints
//     double totalDistance = 0;
//     LocationPoint current = start;

//     for (DummyLocation waypoint in waypoints) {
//       totalDistance += _calculateDistance(
//         current.latitude,
//         current.longitude,
//         waypoint.latitude,
//         waypoint.longitude,
//       );
//       current = LocationPoint(
//         latitude: waypoint.latitude,
//         longitude: waypoint.longitude,
//         address: waypoint.name,
//       );
//     }

//     // Add distance from last waypoint to end
//     totalDistance += _calculateDistance(
//       current.latitude,
//       current.longitude,
//       end.latitude,
//       end.longitude,
//     );

//     // Calculate direct distance
//     double directDistance = _calculateDistance(
//       start.latitude,
//       start.longitude,
//       end.latitude,
//       end.longitude,
//     );

//     // Consider route optimal if total distance is not more than 50% longer than direct route
//     double threshold = directDistance * 1.5;
//     return totalDistance <= threshold;
//   }

//   // Helper method to calculate distance between two points
//   static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double earthRadius = 6371000; // Earth's radius in meters
    
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
    
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//         sin(dLon / 2) * sin(dLon / 2);
    
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
//     return earthRadius * c;
//   }

//   static double _toRadians(double degree) {
//     return degree * (pi / 180);
//   }

//   // Get all dummy stores (for testing purposes)
//   static List<DummyLocation> getAllStores() {
//     return List.from(_dummyStores);
//   }

//   // Add new store location
//   static void addStore(DummyLocation store) {
//     _dummyStores.add(store);
//   }

//   // Remove store by ID
//   static void removeStore(int storeId) {
//     _dummyStores.removeWhere((store) => store.id == storeId);
//   }
// }

import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';
import '../models/champion_location.dart';

class RouteOptimizationService {
  /// Find ChampionLocations close to the route (within maxDistanceFromRoute)
  static List<ChampionLocation> findLocationsOnRoute(
    LocationPoint start,
    LocationPoint end,
    List<LatLng> routePoints,
    List<Map<String, dynamic>> champions, // From Supabase
    {double maxDistanceFromRoute = 2000} // in meters
  ) {
    List<ChampionLocation> locationsOnRoute = [];

    for (var champ in champions) {
      double minDistance = double.infinity;

      for (LatLng routePoint in routePoints) {
        double distance = _calculateDistance(
          champ['latitude'],
          champ['longitude'],
          routePoint.latitude,
          routePoint.longitude,
        );
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      if (minDistance <= maxDistanceFromRoute) {
        locationsOnRoute.add(ChampionLocation(
          id: champ['id'],
          latitude: champ['latitude'],
          longitude: champ['longitude'],
          name: champ['name'],
          // communityArea: champ['community']['area'] ?? 'unknown',
          communityArea: champ['community']?['area'] ?? 'unknown',
          isOnRoute: true,
          distanceFromRoute: minDistance,
          flag: champ['flag'] ?? 0,
        ));
      }
    }

    return locationsOnRoute;
  }

  // /// Optimize waypoints using a nearest-neighbor algorithm
  // static List<ChampionLocation>optimizeChampionWaypoints(
  //   LocationPoint start,
  //   List<Map<String, dynamic>> selectedChampions,
  //   LocationPoint end,
  // ) {
  //   if (selectedChampions.isEmpty) return [];

  //   List<ChampionLocation> remaining = selectedChampions.map((champ) => ChampionLocation(
  //     id: champ['id'],
  //     latitude: champ['latitude'],
  //     longitude: champ['longitude'],
  //     name: champ['name'],
  //     // communityArea: champ['community']['area'] ?? 'unknown',
  //     communityArea: champ['community']?['area'] ?? 'unknown',
  //     flag: champ['flag'] ?? 0,
  //   )).toList();

  //   List<ChampionLocation> optimized = [];
  //   LocationPoint currentLocation = start;

  //   while (remaining.isNotEmpty) {
  //     ChampionLocation nearest = remaining.first;
  //     double nearestDistance = _calculateDistance(
  //       currentLocation.latitude,
  //       currentLocation.longitude,
  //       nearest.latitude,
  //       nearest.longitude,
  //     );

  //     for (var waypoint in remaining) {
  //       double distance = _calculateDistance(
  //         currentLocation.latitude,
  //         currentLocation.longitude,
  //         waypoint.latitude,
  //         waypoint.longitude,
  //       );

  //       if (distance < nearestDistance) {
  //         nearest = waypoint;
  //         nearestDistance = distance;
  //       }
  //     }

  //     optimized.add(nearest);
  //     remaining.remove(nearest);
  //     currentLocation = LocationPoint(
  //       latitude: nearest.latitude,
  //       longitude: nearest.longitude,
  //       address: nearest.name,
  //     );
  //   }

  //   return optimized;
  // }



static List<ChampionLocation> optimizeChampionWaypoints(
  LocationPoint start,
  List<Map<String, dynamic>> selectedChampions,
  LocationPoint end,
) {
  if (selectedChampions.isEmpty) return [];

  List<ChampionLocation> remaining = selectedChampions.map((champ) {
    return ChampionLocation(
      id: champ['id'],
      latitude: champ['latitude'],
      longitude: champ['longitude'],
      name: champ['name'],
      communityArea: champ['community']?['area'] ?? 'unknown',
      flag: champ['flag'] ?? 0,
    );
  }).toList();

  List<ChampionLocation> optimized = [];
  LocationPoint currentLocation = start;

  while (remaining.isNotEmpty) {
    ChampionLocation nearest = remaining.first;
    double nearestDistance = _calculateDistance(
      currentLocation.latitude,
      currentLocation.longitude,
      nearest.latitude,
      nearest.longitude,
    );

    for (var waypoint in remaining) {
      double distance = _calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        waypoint.latitude,
        waypoint.longitude,
      );

      if (distance < nearestDistance) {
        nearest = waypoint;
        nearestDistance = distance;
      }
    }

    // ✅ FIX: Create a new ChampionLocation with distanceFromRoute set
    optimized.add(
      ChampionLocation(
        id: nearest.id,
        latitude: nearest.latitude,
        longitude: nearest.longitude,
        name: nearest.name,
        communityArea: nearest.communityArea,
        distanceFromRoute: nearestDistance, // ✅ Set distance
        flag: nearest.flag,
        isOnRoute: true,
      ),
    );

    remaining.remove(nearest);
    currentLocation = LocationPoint(
      latitude: nearest.latitude,
      longitude: nearest.longitude,
      address: nearest.name,
    );
  }

  return optimized;
}

  /// Heuristic to check if optimized route is acceptable
  static bool isRouteOptimal(
    LocationPoint start,
    LocationPoint end,
    List<ChampionLocation> waypoints,
  ) {
    if (waypoints.isEmpty) return true;

    double totalDistance = 0;
    LocationPoint current = start;

    for (ChampionLocation waypoint in waypoints) {
      totalDistance += _calculateDistance(
        current.latitude,
        current.longitude,
        waypoint.latitude,
        waypoint.longitude,
      );
      current = LocationPoint(
        latitude: waypoint.latitude,
        longitude: waypoint.longitude,
        address: waypoint.name,
      );
    }

    totalDistance += _calculateDistance(
      current.latitude,
      current.longitude,
      end.latitude,
      end.longitude,
    );

    double directDistance = _calculateDistance(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    return totalDistance <= directDistance * 1.5;
  }

  /// Haversine formula to compute distance in meters
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180);
  }
  
  static bool isLocationNearRoute(
  double latitude,
  double longitude,
  List<LatLng> routePoints,
  double maxDistanceMeters,
) {
  for (LatLng point in routePoints) {
    double distance = _calculateDistance(
      latitude, longitude,
      point.latitude, point.longitude,
    );
    if (distance <= maxDistanceMeters) {
      return true;
    }
  }
  return false;
}
}

