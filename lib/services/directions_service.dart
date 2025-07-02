import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';

// class DirectionsService {
//   // Using OpenRouteService API (free alternative to Google Maps)
//   // You can also use Google Maps Directions API with your API key
//   static const String _baseUrl = 'https://router.project-osrm.org/route/v1/driving';

//   static Future<List<LatLng>> getDirections(
//     LocationPoint start,
//     LocationPoint end,
//   ) async {
//     try {
//       final url = '$_baseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
      
//       final response = await http.get(Uri.parse(url));
      
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final coordinates = data['routes'][0]['geometry']['coordinates'] as List;
        
//         return coordinates.map<LatLng>((coord) {
//           return LatLng(coord[1].toDouble(), coord[0].toDouble());
//         }).toList();
//       } else {
//         print('Error getting directions: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error in getDirections: $e');
//       return [];
//     }
//   }

//   // Alternative: Simple straight line between points
//   static List<LatLng> getStraightLineRoute(LocationPoint start, LocationPoint end) {
//     return [
//       LatLng(start.latitude, start.longitude),
//       LatLng(end.latitude, end.longitude),
//     ];
//   }
// }

class DirectionsService {
  // Using OSRM API (free alternative to Google Maps)
  static const String _baseUrl = 'https://router.project-osrm.org/route/v1/driving';

  static Future<List<LatLng>> getDirections(
    LocationPoint start,
    LocationPoint end,
  ) async {
    try {
      final url = '$_baseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final coordinates = data['routes'][0]['geometry']['coordinates'] as List;
          
          return coordinates.map<LatLng>((coord) {
            return LatLng(coord[1].toDouble(), coord[0].toDouble());
          }).toList();
        }
      } else {
        print('Error getting directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getDirections: $e');
    }
    return [];
  }

  // Get directions with waypoints
  static Future<List<LatLng>> getDirectionsWithWaypoints(
    LocationPoint start,
    List<DummyLocation> waypoints,
    LocationPoint end,
  ) async {
    if (waypoints.isEmpty) {
      return getDirections(start, end);
    }

    try {
      // Build coordinates string: start;waypoint1;waypoint2;...;end
      String coordinates = '${start.longitude},${start.latitude}';
      
      for (DummyLocation waypoint in waypoints) {
        coordinates += ';${waypoint.longitude},${waypoint.latitude}';
      }
      
      coordinates += ';${end.longitude},${end.latitude}';
      
      final url = '$_baseUrl/$coordinates?overview=full&geometries=geojson';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final routeCoordinates = data['routes'][0]['geometry']['coordinates'] as List;
          
          return routeCoordinates.map<LatLng>((coord) {
            return LatLng(coord[1].toDouble(), coord[0].toDouble());
          }).toList();
        }
      } else {
        print('Error getting directions with waypoints: ${response.statusCode}');
        // Fallback to basic route if waypoint routing fails
        return getDirections(start, end);
      }
    } catch (e) {
      print('Error in getDirectionsWithWaypoints: $e');
      // Fallback to basic route
      return getDirections(start, end);
    }
    return [];
  }

  // Alternative: Simple straight line between points
  static List<LatLng> getStraightLineRoute(LocationPoint start, LocationPoint end) {
    return [
      LatLng(start.latitude, start.longitude),
      LatLng(end.latitude, end.longitude),
    ];
  }

  // Get route with multiple waypoints using straight lines (fallback)
  static List<LatLng> getStraightLineRouteWithWaypoints(
    LocationPoint start,
    List<DummyLocation> waypoints,
    LocationPoint end,
  ) {
    List<LatLng> route = [];
    
    // Add start point
    route.add(LatLng(start.latitude, start.longitude));
    
    // Add waypoints
    for (DummyLocation waypoint in waypoints) {
      route.add(LatLng(waypoint.latitude, waypoint.longitude));
    }
    
    // Add end point
    route.add(LatLng(end.latitude, end.longitude));
    
    return route;
  }

  // Get route information (distance, duration)
  static Future<Map<String, dynamic>?> getRouteInfo(
    LocationPoint start,
    LocationPoint end,
  ) async {
    try {
      final url = '$_baseUrl/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          return {
            'distance': route['distance']?.toDouble() ?? 0.0, // in meters
            'duration': route['duration']?.toDouble() ?? 0.0, // in seconds
          };
        }
      }
    } catch (e) {
      print('Error getting route info: $e');
    }
    return null;
  }
}