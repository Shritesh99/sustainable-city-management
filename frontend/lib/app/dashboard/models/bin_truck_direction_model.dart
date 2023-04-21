import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
  });

  static final nullReturn = Directions(
      bounds: LatLngBounds(
          northeast: const LatLng(53.2, -6), southwest: const LatLng(53.1, -6)),
      polylinePoints: []);

  static Directions fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['routes'] as List).isEmpty) return nullReturn;

    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    List<PointLatLng> pointList = [];

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      pointList = decodeLine(data['overview_polyline']['points']);
    }

    return Directions(
      bounds: bounds,
      polylinePoints: pointList,
    );
  }

  static List<PointLatLng> decodeLine(encoded) {
    var len = encoded.length;
    var index = 0;
    var array = <PointLatLng>[];
    var lat = 0;
    var lng = 0;

    while (index < len) {
      var b;
      var shift = 0;
      var result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      var tmpResLat = result & 1;
      var dlat = tmpResLat == 1 ? ~(result >> 1) : result >> 1;
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      var tmpResLng = result & 1;
      var dlng = tmpResLng == 1 ? ~(result >> 1) : result >> 1;
      lng += dlng;

      array.add(PointLatLng(lat * 1e-5, lng * 1e-5));
    }

    return array;
  }
}
