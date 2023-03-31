// To parse this JSON data, do
//
//     final bikeStationModel = bikeStationModelFromJson(jsonString);

import 'dart:convert';

BikeStationModel bikeStationModelFromMap(Map<String, dynamic> map) =>
    BikeStationModel.fromJson(map);

String bikeStationModelToJson(BikeStationModel data) =>
    json.encode(data.toJson());

class BikeStationModel {
  BikeStationModel({
    required this.number,
    required this.contractName,
    required this.name,
    required this.address,
    required this.position,
    required this.banking,
    required this.bonus,
    required this.status,
    required this.lastUpdate,
    required this.connected,
    required this.overflow,
    this.shape,
    required this.totalStands,
    required this.mainStands,
    this.overflowStands,
  });

  int number;
  String contractName;
  String name;
  String address;
  Position position;
  bool banking;
  bool bonus;
  String status;
  DateTime lastUpdate;
  bool connected;
  bool overflow;
  dynamic shape;
  Stands totalStands;
  Stands mainStands;
  dynamic overflowStands;

  factory BikeStationModel.fromJson(Map<String, dynamic> json) =>
      BikeStationModel(
        number: json["number"],
        contractName: json["contractName"],
        name: json["name"],
        address: json["address"],
        position: Position.fromJson(json["position"]),
        banking: json["banking"],
        bonus: json["bonus"],
        status: json["status"],
        lastUpdate: DateTime.parse(json["lastUpdate"]),
        connected: json["connected"],
        overflow: json["overflow"],
        shape: json["shape"],
        totalStands: Stands.fromJson(json["totalStands"]),
        mainStands: Stands.fromJson(json["mainStands"]),
        overflowStands: json["overflowStands"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "contractName": contractName,
        "name": name,
        "address": address,
        "position": position.toJson(),
        "banking": banking,
        "bonus": bonus,
        "status": status,
        "lastUpdate": lastUpdate.toIso8601String(),
        "connected": connected,
        "overflow": overflow,
        "shape": shape,
        "totalStands": totalStands.toJson(),
        "mainStands": mainStands.toJson(),
        "overflowStands": overflowStands,
      };
}

class Stands {
  Stands({
    required this.availabilities,
    required this.capacity,
  });

  Availabilities availabilities;
  int capacity;

  factory Stands.fromJson(Map<String, dynamic> json) => Stands(
        availabilities: Availabilities.fromJson(json["availabilities"]),
        capacity: json["capacity"],
      );

  Map<String, dynamic> toJson() => {
        "availabilities": availabilities.toJson(),
        "capacity": capacity,
      };
}

class Availabilities {
  Availabilities({
    required this.bikes,
    required this.stands,
    required this.mechanicalBikes,
    required this.electricalBikes,
    required this.electricalInternalBatteryBikes,
    required this.electricalRemovableBatteryBikes,
  });

  int bikes;
  int stands;
  int mechanicalBikes;
  int electricalBikes;
  int electricalInternalBatteryBikes;
  int electricalRemovableBatteryBikes;

  factory Availabilities.fromJson(Map<String, dynamic> json) => Availabilities(
        bikes: json["bikes"],
        stands: json["stands"],
        mechanicalBikes: json["mechanicalBikes"],
        electricalBikes: json["electricalBikes"],
        electricalInternalBatteryBikes: json["electricalInternalBatteryBikes"],
        electricalRemovableBatteryBikes:
            json["electricalRemovableBatteryBikes"],
      );

  Map<String, dynamic> toJson() => {
        "bikes": bikes,
        "stands": stands,
        "mechanicalBikes": mechanicalBikes,
        "electricalBikes": electricalBikes,
        "electricalInternalBatteryBikes": electricalInternalBatteryBikes,
        "electricalRemovableBatteryBikes": electricalRemovableBatteryBikes,
      };
}

class Position {
  Position({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
