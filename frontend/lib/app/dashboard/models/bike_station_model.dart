import 'dart:convert';

BikeStationModel busModelFromJson(String str) =>
    BikeStationModel.fromJson(json.decode(str));

String busModelToJson(BikeStationModel data) => json.encode(data.toJson());

class BikeStationModel {
  BikeStationModel({
    required this.id,
    required this.contractName,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lastUpdate,
    required this.bikes,
    required this.stands,
    this.mechanicalBikes,
    this.electricalBikes,
  });

  int id;
  String contractName;
  String name;
  String address;
  double latitude;
  double longitude;
  String status;
  int lastUpdate;
  int bikes;
  int stands;
  int? mechanicalBikes;
  int? electricalBikes;

  factory BikeStationModel.fromJson(Map<String, dynamic> json) =>
      BikeStationModel(
        id: json["id"],
        contractName: json["contractName"],
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        status: json["status"],
        lastUpdate: json["lastUpdate"],
        bikes: json["bikes"],
        stands: json["stands"],
        mechanicalBikes: json["mechanicalBikes"],
        electricalBikes: json["electricalBikes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contractName": contractName,
        "name": name,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "lastUpdate": lastUpdate,
        "bikes": bikes,
        "stands": stands,
        "mechanicalBikes": mechanicalBikes,
        "electricalBikes": electricalBikes,
      };
}
