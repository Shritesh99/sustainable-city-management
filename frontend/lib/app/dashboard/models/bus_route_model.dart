// To parse this JSON data, do
//
//     final busRouteModel = busRouteModelFromJson(jsonString);

import 'dart:convert';

BusRouteModel busRouteModelFromJson(String str) =>
    BusRouteModel.fromJson(json.decode(str));

String busRouteModelToJson(BusRouteModel data) => json.encode(data.toJson());

class BusRouteModel {
  BusRouteModel({
    required this.type,
    required this.features,
  });

  String type;
  List<Feature> features;

  factory BusRouteModel.fromJson(Map<String, dynamic> json) => BusRouteModel(
        type: json["type"],
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
      };
}

class Feature {
  Feature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  String type;
  Properties properties;
  Geometry geometry;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        properties: Properties.fromJson(json["properties"]),
        geometry: Geometry.fromJson(json["geometry"]),
      );

  set isActive(bool isActive) {}

  Map<String, dynamic> toJson() => {
        "type": type,
        "properties": properties.toJson(),
        "geometry": geometry.toJson(),
      };
}

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<List<double>> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<List<double>>.from(json["coordinates"]
            .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(
            coordinates.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class Properties {
  Properties({
    required this.agencyName,
    required this.routeId,
    required this.agencyId,
    required this.routeShortName,
    required this.routeLongName,
    required this.routeType,
  });

  String agencyName;
  String routeId;
  String agencyId;
  String routeShortName;
  String routeLongName;
  int routeType;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        agencyName: json["agency_name"],
        routeId: json["route_id"],
        agencyId: json["agency_id"],
        routeShortName: json["route_short_name"],
        routeLongName: json["route_long_name"],
        routeType: json["route_type"],
      );

  Map<String, dynamic> toJson() => {
        "agency_name": agencyName,
        "route_id": routeId,
        "agency_id": agencyId,
        "route_short_name": routeShortName,
        "route_long_name": routeLongName,
        "route_type": routeType,
      };
}
