import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_station_model.dart';
import '../constants/app_constants.dart';
import '../dashboard/models/air_index_model.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';

class AirServices {
  static final AirServices _airServices = AirServices._internal();
  // static final dioClient = DioClient().dio;
  factory AirServices({Dio? dio}) {
    if (_airServices._dioInstance == null) {
      _airServices._setDio(dio);
    }
    return _airServices;
  }

  AirServices._internal();

  Dio? _dioInstance;

  void _setDio(Dio? dio) {
    _dioInstance ??= dio ?? DioClient().dio;
  }

  Dio get dioClient => _dioInstance!;

  Future<List<AirStation>> listAirStation(bool isFocastMode) async {
    List<AirStation> airStationModels = <AirStation>[];
    var uri;
    if (!isFocastMode) {
      uri = Uri.parse(ApiPath.airStation);
    } else {
      uri = Uri.parse(ApiPath.airStationPredict);
    }
    Response rsp = await dioClient.getUri(uri);
    List<dynamic> stations = [];
    if (!isFocastMode) {
      stations = rsp.data["aqi_data"]["airData"] as List;
    } else {
      stations =
          rsp.data["predicted_air_stations"]["predictedAirStations"] as List;
    }
    for (var station in stations) {
      if (station["aqi"] != null) {
        airStationModels.add(AirStation.fromJson(station));
      }
    }

    return airStationModels;
  }

  Future<AqiData> getAirIndices(String stationId, bool isFocastMode) async {
    var uri;
    if (!isFocastMode) {
      uri = Uri.parse("${ApiPath.airIndex}?id=$stationId");
    } else {
      uri = Uri.parse("${ApiPath.airIndexPredict}?id=$stationId");
    }
    Response rsp = await dioClient.getUri(uri);

    if (!isFocastMode) {
      return AqiData.fromJson(rsp.data["aqi_data"]);
    } else {
      return AqiData.fromJson(rsp.data["predicted_detailed_data"]);
    }
  }
}
