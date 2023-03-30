import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sustainable_city_management/app/features/dashboard/models/air_station_model.dart';
import '../../constans/app_constants.dart';
import '../../features/dashboard/models/air_index_model.dart';

class AirServices {
  static final AirServices _bikeServices = AirServices._internal();

  factory AirServices() {
    return _bikeServices;
  }
  AirServices._internal();

  Future<List<AirStation>> listAirStation() async {
    List<AirStation> airStationModels = <AirStation>[];
    var uri = Uri.parse(ApiPath.airStation);
    try {
      Response rsp;
      rsp = await Dio().getUri(uri);
      List<dynamic> stations = rsp.data["aqi_data"]["airData"] as List;
      for (var station in stations) {
        airStationModels.add(AirStation.fromJson(station));
      }
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch air data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch air data $e');
    }

    return airStationModels;
  }

  Future<AqiData> getAirIndices(String stationId) async {
    late AqiData aqiData;
    var uri = Uri.parse("${ApiPath.airIndex}?id=$stationId");
    try {
      Response rsp;
      rsp = await Dio().getUri(uri);
      // print(rsp.data);
      aqiData = AqiData.fromJson(rsp.data["aqi_data"]);
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch air data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch air data $e');
    }

    return aqiData;
  }
}
