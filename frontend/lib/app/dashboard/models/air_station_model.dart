class AirStation {
  AirStation({
    required this.stationId,
    this.stationName,
    required this.latitude,
    required this.longitude,
    this.aqi,
  });

  String stationId;
  String? stationName;
  double latitude;
  double longitude;
  int? aqi;

  factory AirStation.fromJson(Map<String, dynamic> json) => AirStation(
        stationId: json["stationID"],
        stationName: json["stationName"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        aqi: json["aqi"],
      );

  Map<String, dynamic> toJson() => {
        "stationID": stationId,
        "stationName": stationName,
        "latitude": latitude,
        "longitude": longitude,
        "aqi": aqi,
      };
}
