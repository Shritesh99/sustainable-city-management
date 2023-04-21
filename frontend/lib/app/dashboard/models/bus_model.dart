// To parse this JSON data, do
//
//     final busModel = busModelFromJson(jsonString);

import 'dart:convert';

BusModel busModelFromJson(String str) => BusModel.fromJson(json.decode(str));

String busModelToJson(BusModel data) => json.encode(data.toJson());

class BusModel {
  BusModel({
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.routeId,
  });

  String vehicleId;
  double latitude;
  double longitude;
  String routeId;

  factory BusModel.fromJson(Map<String, dynamic> json) => BusModel(
        vehicleId: json["vehicleID"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        routeId: json["routeID"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleID": vehicleId,
        "latitude": latitude,
        "longitude": longitude,
        "routeID": routeId,
      };
}
