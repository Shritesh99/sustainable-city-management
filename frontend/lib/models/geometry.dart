//import 'package:google_maps_flutter_geojson/models/models.dart';
import '../models/models.dart';
//import 'package:google_maps_flutter_geojson';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';

abstract class Geometry {
  final String type;

  Geometry(this.type);

  factory Geometry.fromJson(Map<String, dynamic> json) {
    var jsonType = json['type'];
    assert(jsonType != null);

    switch (jsonType) {
      case 'Point':
        return Point.fromJson(json);
      case 'LineString':
        return LineString.fromJson(json);
      case 'Polygon':
        return Polygon.fromJson(json);
      default:
        throw Exception('Cannot parse geojson');
    }
  }
}
