// To parse this JSON data, do
//
//     final airQualityModel = airQualityModelFromJson(jsonString);

import 'dart:convert';

AirQualityModel airQualityModelFromJson(Map<String, dynamic> json) =>
    AirQualityModel.fromJson(json);

String airQualityModelToJson(AirQualityModel data) =>
    json.encode(data.toJson());

class AirQualityModel {
  AirQualityModel({
    required this.aqiData,
  });

  AqiData aqiData;

  factory AirQualityModel.fromJson(Map<String, dynamic> jsonMap) =>
      AirQualityModel(
        aqiData: AqiData.fromJson(json.decode(jsonMap["aqi_data"])),
      );

  Map<String, dynamic> toJson() => {
        "aqi_data": aqiData.toJson(),
      };
}

class AqiData {
  AqiData({
    required this.id,
    required this.stationId,
    required this.stationName,
    required this.aqi,
    required this.measureTime,
    this.epa,
    this.pm25,
    this.pm10,
    this.ozone,
    this.no2,
    this.so2,
    this.co,
    required this.insertTime,
    required this.updatedTime,
    required this.latitude,
    required this.longitude,
  });

  int id;
  String stationId;
  String stationName;
  int aqi;
  DateTime? measureTime;
  String? epa;
  int? pm25;
  int? pm10;
  double? ozone;
  int? no2;
  int? so2;
  int? co;
  DateTime insertTime;
  DateTime updatedTime;
  double latitude;
  double longitude;

  factory AqiData.fromJson(Map<String, dynamic> json) => AqiData(
        id: json["id"],
        stationId: json["station_id"],
        stationName: json["station_name"],
        aqi: json["aqi"],
        measureTime: DateTime.parse(json["measure_time"]),
        epa: json["epa"],
        pm25: json["pm25"],
        pm10: json["pm10"],
        ozone: json["ozone"].toDouble(),
        no2: json["no2"],
        so2: json["so2"],
        co: json["co"],
        insertTime: DateTime.parse(json["insert_time"]),
        updatedTime: DateTime.parse(json["updated_time"]),
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "station_id": stationId,
        "station_name": stationName,
        "aqi": aqi,
        "measure_time": measureTime?.toIso8601String(),
        "epa": epa,
        "pm25": pm25,
        "pm10": pm10,
        "ozone": ozone,
        "no2": no2,
        "so2": so2,
        "co": co,
        "insert_time": insertTime.toIso8601String(),
        "updated_time": updatedTime.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
      };
}
