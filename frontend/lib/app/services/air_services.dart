import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_station_model.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import '../constans/app_constants.dart';
import '../dashboard/models/air_index_model.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';

class AirServices {
  static final AirServices _bikeServices = AirServices._internal();

  factory AirServices() {
    return _bikeServices;
  }
  AirServices._internal();

  Future<List<AirStation>> listAirStation() async {
    List<AirStation> airStationModels = <AirStation>[];
    var uri = Uri.parse(ApiPath.airStation);
    Response rsp = await dioClient.getUri(uri);
    List<dynamic> stations = rsp.data["aqi_data"]["airData"] as List;
    for (var station in stations) {
      if (station["aqi"] != null) {
        airStationModels.add(AirStation.fromJson(station));
      }
    }

    return airStationModels;
  }

  Future<AqiData> getAirIndices(String stationId) async {
    var uri = Uri.parse("${ApiPath.airIndex}?id=$stationId");
    Response rsp = await dioClient.getUri(uri);
    return AqiData.fromJson(rsp.data["aqi_data"]);
  }
}
