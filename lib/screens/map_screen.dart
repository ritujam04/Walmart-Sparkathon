// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import '../models/location_model.dart';
// import '../services/location_service.dart';
// import '../services/directions_service.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final MapController _mapController = MapController();
//   final TextEditingController _startController = TextEditingController();
//   final TextEditingController _endController = TextEditingController();
  
//   LocationPoint? startLocation;
//   LocationPoint? endLocation;
//   List<LatLng> routePoints = [];
//   bool isLoading = false;
//   String? errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map Directions'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Input Section
//           Container(
//             padding: EdgeInsets.all(16),
//             color: Colors.grey[100],
//             child: Column(
//               children: [
//                 // Start Location Input
//                 TextField(
//                   controller: _startController,
//                   decoration: InputDecoration(
//                     labelText: 'Start Location',
//                     hintText: 'Enter starting address',
//                     prefixIcon: Icon(Icons.location_on, color: Colors.green),
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.my_location),
//                       onPressed: _useCurrentLocation,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 12),
                
//                 // End Location Input
//                 TextField(
//                   controller: _endController,
//                   decoration: InputDecoration(
//                     labelText: 'End Location',
//                     hintText: 'Enter destination address',
//                     prefixIcon: Icon(Icons.location_on, color: Colors.red),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
                
//                 // Get Directions Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : _getDirections,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     child: isLoading
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               ),
//                               SizedBox(width: 12),
//                               Text('Getting Directions...'),
//                             ],
//                           )
//                         : Text('Get Directions'),
//                   ),
//                 ),
                
//                 // Error Message
//                 if (errorMessage != null)
//                   Container(
//                     margin: EdgeInsets.only(top: 8),
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.red[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       errorMessage!,
//                       style: TextStyle(color: Colors.red[800]),
//                     ),
//                   ),
//               ],
//             ),
//           ),
          
//           // Map Section
//           Expanded(
//             child: FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 center: LatLng(20.5937, 78.9629), // Center of India
//                 zoom: 5.0,
//                 minZoom: 3.0,
//                 maxZoom: 18.0,
//               ),
//               children: [
//                 // Tile Layer
//                 TileLayer(
//                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                   userAgentPackageName: 'com.example.map_directions_app',
//                 ),
                
//                 // Route Polyline
//                 if (routePoints.isNotEmpty)
//                   PolylineLayer(
//                     polylines: [
//                       Polyline(
//                         points: routePoints,
//                         color: Colors.blue,
//                         strokeWidth: 4.0,
//                       ),
//                     ],
//                   ),
                
//                 // Markers
//                 MarkerLayer(
//                   markers: _buildMarkers(),
//                 ),
//               ],
//             ),
//           ),
          
//           // Info Section
//           if (startLocation != null && endLocation != null)
//             Container(
//               padding: EdgeInsets.all(16),
//               color: Colors.grey[100],
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Route Information',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Distance: ${_formatDistance(LocationService.calculateDistance(startLocation!, endLocation!))}',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'From: ${startLocation!.address}',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     'To: ${endLocation!.address}',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   List<Marker> _buildMarkers() {
//     List<Marker> markers = [];
    
//     if (startLocation != null) {
//       markers.add(
//         Marker(
//           point: LatLng(startLocation!.latitude, startLocation!.longitude),
//           child: Container(
//             child: Icon(
//               Icons.location_on,
//               color: Colors.green,
//               size: 40,
//             ),
//           ),
//         ),
//       );
//     }
    
//     if (endLocation != null) {
//       markers.add(
//         Marker(
//           point: LatLng(endLocation!.latitude, endLocation!.longitude),
//           child: Container(
//             child: Icon(
//               Icons.location_on,
//               color: Colors.red,
//               size: 40,
//             ),
//           ),
//         ),
//       );
//     }
    
//     return markers;
//   }

//   Future<void> _useCurrentLocation() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       LocationPoint? currentLocation = await LocationService.getCurrentLocation();
//       if (currentLocation != null) {
//         setState(() {
//           _startController.text = currentLocation.address;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Could not get current location';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error getting current location: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _getDirections() async {
//     if (_startController.text.isEmpty || _endController.text.isEmpty) {
//       setState(() {
//         errorMessage = 'Please enter both start and end locations';
//       });
//       return;
//     }

//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     try {
//       // Get coordinates for both locations
//       LocationPoint? start = await LocationService.getCoordinatesFromAddress(_startController.text);
//       LocationPoint? end = await LocationService.getCoordinatesFromAddress(_endController.text);

//       if (start == null || end == null) {
//         setState(() {
//           errorMessage = 'Could not find one or both locations. Please check the addresses.';
//         });
//         return;
//       }

//       // Get route directions
//       List<LatLng> route = await DirectionsService.getDirections(start, end);
      
//       // If no route found, use straight line
//       if (route.isEmpty) {
//         route = DirectionsService.getStraightLineRoute(start, end);
//       }

//       setState(() {
//         startLocation = start;
//         endLocation = end;
//         routePoints = route;
//       });

//       // Fit map to show both points
//       _fitMapToRoute();

//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error getting directions: $e';
//       });
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void _fitMapToRoute() {
//     if (startLocation != null && endLocation != null) {
//       double minLat = [startLocation!.latitude, endLocation!.latitude].reduce((a, b) => a < b ? a : b);
//       double maxLat = [startLocation!.latitude, endLocation!.latitude].reduce((a, b) => a > b ? a : b);
//       double minLng = [startLocation!.longitude, endLocation!.longitude].reduce((a, b) => a < b ? a : b);
//       double maxLng = [startLocation!.longitude, endLocation!.longitude].reduce((a, b) => a > b ? a : b);

//       double centerLat = (minLat + maxLat) / 2;
//       double centerLng = (minLng + maxLng) / 2;

//       _mapController.move(LatLng(centerLat, centerLng), 10.0);
//     }
//   }

//   String _formatDistance(double distanceInMeters) {
//     if (distanceInMeters < 1000) {
//       return '${distanceInMeters.toStringAsFixed(0)} m';
//     } else {
//       return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
//     }
//   }

//   @override
//   void dispose() {
//     _startController.dispose();
//     _endController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
import '../services/route_optimization_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  
  LocationPoint? startLocation;
  LocationPoint? endLocation;
  List<LatLng> routePoints = [];
  List<DummyLocation> waypointsOnRoute = [];
  bool isLoading = false;
  String? errorMessage;
  bool isRouteOptimal = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Route Planner'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Input Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                // Start Location Input
                TextField(
                  controller: _startController,
                  decoration: InputDecoration(
                    labelText: 'Start Location',
                    hintText: 'Enter starting address',
                    prefixIcon: Icon(Icons.location_on, color: Colors.green),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: _useCurrentLocation,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                
                // End Location Input
                TextField(
                  controller: _endController,
                  decoration: InputDecoration(
                    labelText: 'End Location',
                    hintText: 'Enter destination address',
                    prefixIcon: Icon(Icons.location_on, color: Colors.red),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                
                // Get Directions Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _getSmartDirections,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Finding Smart Route...'),
                            ],
                          )
                        : Text('Get Smart Directions'),
                  ),
                ),
                
                // Clear Route Button
                if (routePoints.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _clearRoute,
                      child: Text('Clear Route'),
                    ),
                  ),
                
                // Route Optimization Status
                if (waypointsOnRoute.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isRouteOptimal ? Colors.green[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isRouteOptimal ? Icons.check_circle : Icons.warning,
                          color: isRouteOptimal ? Colors.green[800] : Colors.orange[800],
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isRouteOptimal 
                                ? 'Route is optimized with ${waypointsOnRoute.length} waypoints'
                                : 'Route can be optimized further',
                            style: TextStyle(
                              color: isRouteOptimal ? Colors.green[800] : Colors.orange[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Error Message
                if (errorMessage != null)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ),
              ],
            ),
          ),
          
          // Map Section
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(20.5937, 78.9629), // Center of India - Fixed deprecated 'center'
                initialZoom: 5.0, // Fixed deprecated 'zoom'
                minZoom: 3.0,
                maxZoom: 18.0,
              ),
              children: [
                // Tile Layer
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.map_directions_app',
                ),
                
                // Route Polyline
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
                
                // Markers
                MarkerLayer(
                  markers: _buildMarkers(),
                ),
              ],
            ),
          ),
          
          // Info Section
          if (startLocation != null && endLocation != null)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Distance: ${_formatDistance(LocationService.calculateDistance(startLocation!, endLocation!))}',
                    style: TextStyle(fontSize: 14),
                  ),
                  if (waypointsOnRoute.isNotEmpty) ...[
                    Text(
                      'Waypoints: ${waypointsOnRoute.length} locations on route',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: waypointsOnRoute.length,
                        itemBuilder: (context, index) {
                          DummyLocation waypoint = waypointsOnRoute[index];
                          return Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  waypoint.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  waypoint.category,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];
    
    // Start marker
    if (startLocation != null) {
      markers.add(
        Marker(
          point: LatLng(startLocation!.latitude, startLocation!.longitude),
          child: Container(
            child: Icon(
              Icons.location_on,
              color: Colors.green,
              size: 40,
            ),
          ),
        ),
      );
    }
    
    // End marker
    if (endLocation != null) {
      markers.add(
        Marker(
          point: LatLng(endLocation!.latitude, endLocation!.longitude),
          child: Container(
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      );
    }
    
    // Waypoint markers
    for (DummyLocation waypoint in waypointsOnRoute) {
      markers.add(
        Marker(
          point: LatLng(waypoint.latitude, waypoint.longitude),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.orange,
                  size: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange, width: 1),
                  ),
                  child: Text(
                    waypoint.category[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return markers;
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      LocationPoint? currentLocation = await LocationService.getCurrentLocation();
      if (currentLocation != null) {
        setState(() {
          _startController.text = currentLocation.address;
        });
      } else {
        setState(() {
          errorMessage = 'Could not get current location';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error getting current location: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getSmartDirections() async {
    if (_startController.text.isEmpty || _endController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please enter both start and end locations';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      waypointsOnRoute.clear();
    });

    try {
      // Get coordinates for both locations
      LocationPoint? start = await LocationService.getCoordinatesFromAddress(_startController.text);
      LocationPoint? end = await LocationService.getCoordinatesFromAddress(_endController.text);

      if (start == null || end == null) {
        setState(() {
          errorMessage = 'Could not find one or both locations. Please check the addresses.';
        });
        return;
      }

      // Get basic route first
      List<LatLng> basicRoute = await DirectionsService.getDirections(start, end);
      
      if (basicRoute.isEmpty) {
        basicRoute = DirectionsService.getStraightLineRoute(start, end);
      }

      // Find locations on route
      List<DummyLocation> locationsOnRoute = RouteOptimizationService.findLocationsOnRoute(
        start, 
        end, 
        basicRoute
      );

      // Optimize waypoints
      List<DummyLocation> optimizedWaypoints = RouteOptimizationService.optimizeWaypoints(
        start, 
        locationsOnRoute, 
        end
      );

      // Check if route is optimal
      bool routeOptimal = RouteOptimizationService.isRouteOptimal(
        start, 
        end, 
        optimizedWaypoints
      );

      // Get optimized route with waypoints
      List<LatLng> finalRoute = basicRoute;
      if (optimizedWaypoints.isNotEmpty) {
        List<LatLng> optimizedRoute = await DirectionsService.getDirectionsWithWaypoints(
          start, 
          optimizedWaypoints, 
          end
        );
        if (optimizedRoute.isNotEmpty) {
          finalRoute = optimizedRoute;
        }
      }

      setState(() {
        startLocation = start;
        endLocation = end;
        routePoints = finalRoute;
        waypointsOnRoute = optimizedWaypoints;
        isRouteOptimal = routeOptimal;
      });

      // Fit map to show all points
      _fitMapToRoute();

    } catch (e) {
      setState(() {
        errorMessage = 'Error getting smart directions: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Complete the _fitMapToRoute method
  void _fitMapToRoute() {
    if (startLocation != null && endLocation != null) {
      List<double> lats = [startLocation!.latitude, endLocation!.latitude];
      List<double> lngs = [startLocation!.longitude, endLocation!.longitude];
      
      // Include waypoints in bounds
      for (DummyLocation waypoint in waypointsOnRoute) {
        lats.add(waypoint.latitude);
        lngs.add(waypoint.longitude);
      }
      
      double minLat = lats.reduce((a, b) => a < b ? a : b);
      double maxLat = lats.reduce((a, b) => a > b ? a : b);
      double minLng = lngs.reduce((a, b) => a < b ? a : b);
      double maxLng = lngs.reduce((a, b) => a > b ? a : b);
      
      // Add some padding
      double latPadding = (maxLat - minLat) * 0.1;
      double lngPadding = (maxLng - minLng) * 0.1;
      
      LatLngBounds bounds = LatLngBounds(
        LatLng(minLat - latPadding, minLng - lngPadding),
        LatLng(maxLat + latPadding, maxLng + lngPadding),
      );
      
      // Calculate center point
      LatLng center = LatLng(
        (minLat + maxLat) / 2,
        (minLng + maxLng) / 2,
      );
      
      // Calculate appropriate zoom level
      double zoom = _calculateZoomLevel(bounds);
      
      _mapController.move(center, zoom);
    }
  }

  // Calculate appropriate zoom level for the bounds
  double _calculateZoomLevel(LatLngBounds bounds) {
    double latDiff = bounds.north - bounds.south;
    double lngDiff = bounds.east - bounds.west;
    
    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    if (maxDiff > 10) return 5.0;
    if (maxDiff > 5) return 6.0;
    if (maxDiff > 2) return 7.0;
    if (maxDiff > 1) return 8.0;
    if (maxDiff > 0.5) return 9.0;
    if (maxDiff > 0.25) return 10.0;
    if (maxDiff > 0.125) return 11.0;
    if (maxDiff > 0.0625) return 12.0;
    return 13.0;
  }

  // Clear route method
  void _clearRoute() {
    setState(() {
      startLocation = null;
      endLocation = null;
      routePoints.clear();
      waypointsOnRoute.clear();
      errorMessage = null;
      _startController.clear();
      _endController.clear();
    });
  }

  // Add the missing _formatDistance method
  String _formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toStringAsFixed(0)} m';
    } else {
      return '${distanceInKm.toStringAsFixed(2)} km';
    }
  }

  // Add dispose method to clean up controllers
  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }
}