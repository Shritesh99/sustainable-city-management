class AqiData {
  AqiData({
    this.id,
    required this.stationId,
    required this.stationName,
    required this.aqi,
    this.measureTime,
    this.epa,
    this.pm25,
    this.pm10,
    this.ozone,
    this.no2,
    this.so2,
    this.co,
    this.insertTime,
    this.updateTime,
    required this.latitude,
    required this.longitude,
  });

  int? id;
  String stationId;
  String stationName;
  int aqi;
  DateTime? measureTime;
  String? epa;
  int? pm25;
  int? pm10;
  double? ozone;
  double? no2;
  double? so2;
  double? co;
  int? insertTime;
  int? updateTime;
  double latitude;
  double longitude;

  String getIndices() {
    StringBuffer buf = StringBuffer();
    buf.write("Pollutants: ");
    buf.write(pm25 == null ? "" : "pm25: $pm25 ");
    buf.write(pm10 == null ? "" : "pm10: $pm10 ");
    buf.write(ozone == null ? "" : "ozone: $ozone ");
    buf.write(no2 == null ? "" : "no2: $no2 ");
    buf.write(so2 == null ? "" : "so2: $so2 ");
    buf.write(co == null ? "" : "co: $co");
    return buf.toString();
  }

  factory AqiData.fromJson(Map<String, dynamic> json) => AqiData(
        id: json["id"],
        stationId: json["stationId"],
        stationName: json["stationName"],
        aqi: json["aqi"],
        epa: json["epa"],
        pm25: json["pm25"],
        pm10: json["pm10"],
        ozone: json["ozone"],
        no2: json["no2"]?.toDouble(),
        so2: json["so2"],
        co: json["co"],
        insertTime: json["insertTime"],
        updateTime: json["updateTime"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stationId": stationId,
        "stationName": stationName,
        "aqi": aqi,
        "measureTime": measureTime?.toIso8601String(),
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
