// To parse this JSON data, do
//
//     final binPositionModel = binPositionModelFromJson(jsonString);

import 'dart:convert';

BinPositionModel binPositionModelFromMap(Map<String, dynamic> map) =>
    BinPositionModel.fromJson(map);

String binPositionModelToJson(BinPositionModel data) =>
    json.encode(data.toJson());

class BinPositionModel {
  BinPositionModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.status,
  });

  String id;
  double latitude;
  double longitude;
  int region;
  int status;

  factory BinPositionModel.fromJson(Map<String, dynamic> json) =>
      BinPositionModel(
        id: json["id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        region: json["region"],
        status: json["status"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "region": region,
        "status": status,
      };
}
