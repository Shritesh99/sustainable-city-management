class BikeStationInfo {
  int number;
  String stationName;
  String stationAddr;
  int numOfBikeStands;
  int numOfMechanicalBike;
  int numOfElectricBike;
  String status;
  double lat;
  double lng;

  BikeStationInfo(
      {required this.number,
      required this.stationName,
      required this.stationAddr,
      required this.numOfBikeStands,
      required this.numOfMechanicalBike,
      required this.numOfElectricBike,
      required this.status,
      required this.lat,
      required this.lng});
}
