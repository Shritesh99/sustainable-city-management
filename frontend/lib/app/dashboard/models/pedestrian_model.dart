// To parse this JSON data, do
//
//     final pedestrianModel = pedestrianModelFromJson(jsonString);

import 'dart:convert';

PedestrianModel pedestrianModelFromJson(Map<String, dynamic> map) =>
    PedestrianModel.fromJson(map);

String pedestrianModelToJson(PedestrianModel data) =>
    json.encode(data.toJson());

class PedestrianModel {
  PedestrianModel({
    required this.id,
    required this.streetName,
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.amount,
  });

  int id;
  String streetName;
  double latitude;
  double longitude;
  int time;
  int amount;

  factory PedestrianModel.fromJson(Map<String, dynamic> json) =>
      PedestrianModel(
        id: json["id"],
        streetName: json["streetName"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        time: json["time"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "streetName": streetName,
        "latitude": latitude,
        "longitude": longitude,
        "time": time,
        "amount": amount,
      };
}
