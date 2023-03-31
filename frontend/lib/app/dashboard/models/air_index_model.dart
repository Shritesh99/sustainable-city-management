import 'dart:convert';

class AqiData {
  AqiData({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.aqi,
    required this.measureTime,
    required this.epa,
    this.pm25,
    this.pm10,
    this.ozone,
    this.no2,
    this.so2,
    this.co,
    required this.insertTime,
    required this.updateTime,
    required this.latitude,
    required this.longitude,
  });

  int id;
  String stationId;
  String stationName;
  int aqi;
  DateTime measureTime;
  String epa;
  int? pm25;
  int? pm10;
  int? ozone;
  int? no2;
  int? so2;
  int? co;
  int insertTime;
  int updateTime;
  double latitude;
  double longitude;

  factory AqiData.fromJson(Map<String, dynamic> json) => AqiData(
        id: json["id"],
        stationId: json["stationId"],
        stationName: json["stationName"],
        aqi: json["aqi"],
        measureTime: DateTime.parse(json["measureTime"]),
        epa: json["epa"],
        pm25: json["pm25"],
        pm10: json["pm10"],
        ozone: json["ozone"],
        no2: json["no2"],
        so2: json["so2"],
        co: json["co"],
        insertTime: json["insertTime"],
        updateTime: json["updateTime"],
        latitude: json["Latitude"].toDouble(),
        longitude: json["Longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stationId": stationId,
        "stationName": stationName,
        "aqi": aqi,
        "measureTime": measureTime.toIso8601String(),
        "epa": epa,
        "pm25": pm25,
        "pm10": pm10,
        "ozone": ozone,
        "no2": no2,
        "so2": so2,
        "co": co,
        "insertTime": insertTime,
        "updateTime": updateTime,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}
