// To parse this JSON data, do
//
//     final noiseModel = noiseModelFromJson(jsonString);

import 'dart:convert';

NoiseModel noiseModelFromJson(String str) =>
    NoiseModel.fromJson(json.decode(str));

NoiseModel loginModelFromMap(Map<String, dynamic> map) =>
    NoiseModel.fromJson(map);

String noiseModelToJson(NoiseModel data) => json.encode(data.toJson());

class NoiseModel {
  NoiseModel({
    required this.error,
    required this.msg,
    required this.noiseData,
  });

  bool error;
  String msg;
  NoiseData noiseData;

  factory NoiseModel.fromJson(Map<String, dynamic> json) => NoiseModel(
        error: json["error"],
        msg: json["msg"],
        noiseData: NoiseData.fromJson(json["noise_data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "noise_data": noiseData.toJson(),
      };
}

class NoiseData {
  NoiseData({
    required this.noiseData,
  });

  List<NoiseDatum> noiseData;

  factory NoiseData.fromJson(Map<String, dynamic> json) => NoiseData(
        noiseData: List<NoiseDatum>.from(
            json["noiseData"].map((x) => NoiseDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "noiseData": List<dynamic>.from(noiseData.map((x) => x.toJson())),
      };
}

class NoiseDatum {
  NoiseDatum({
    required this.monitorId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.recordTime,
    required this.currentRating,
    required this.laeq,
    required this.dailyAvg,
    required this.hourlyAvg,
  });

  int monitorId;
  String location;
  double latitude;
  double longitude;
  DateTime recordTime;
  int currentRating;
  double laeq;
  double dailyAvg;
  double hourlyAvg;

  factory NoiseDatum.fromJson(Map<String, dynamic> json) => NoiseDatum(
        monitorId: json["monitorID"],
        location: json["location"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        recordTime: DateTime.parse(json["recordTime"]),
        currentRating: json["currentRating"],
        laeq: json["laeq"].toDouble(),
        dailyAvg: json["dailyAvg"].toDouble(),
        hourlyAvg: json["hourlyAvg"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "monitorID": monitorId,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "recordTime": recordTime.toIso8601String(),
        "currentRating": currentRating,
        "laeq": laeq,
        "dailyAvg": dailyAvg,
        "hourlyAvg": hourlyAvg,
      };
  String getIndices() {
    StringBuffer buf = StringBuffer();
    buf.write("Current Record Time: $recordTime\n");
    buf.write("Latest Laeq: $laeq\n");
    buf.write("Hourly Average: $hourlyAvg\n");
    buf.write("Daily Average: $dailyAvg\n");
    return buf.toString();
  }
}
