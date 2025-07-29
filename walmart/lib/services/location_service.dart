import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

class LocationService {
  // Convert address to coordinates
  static Future<LocationPoint?> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return LocationPoint(
          latitude: location.latitude,
          longitude: location.longitude,
          address: address,
        );
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
    return null;
  }

  // Get current location
  static Future<LocationPoint?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      
      String address = "Current Location";
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.street}, ${place.locality}, ${place.country}";
      }

      return LocationPoint(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Calculate distance between two points
  static double calculateDistance(LocationPoint start, LocationPoint end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }
}