import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:js';

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

    // List points =
    //     context.callMethod('decodeLine', [data['overview_polyline']['points']])
    //         as List;
    List<PointLatLng> pointList = [];
    // for (int i = 0; i < points.length; i++) {
    //   pointList
    //       .add(PointLatLng(points[i][0] as double, points[i][1] as double));
    // }
    return Directions(
      bounds: bounds,
      polylinePoints: pointList,
    );
  }
}
