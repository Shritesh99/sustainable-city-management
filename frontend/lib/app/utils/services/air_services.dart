import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../constans/app_constants.dart';
import '../../features/dashboard/models/air_index_model.dart';
import '../../features/dashboard/models/air_quality_model.dart';

class AirServices {
  static final AirServices _bikeServices = AirServices._internal();

  factory AirServices() {
    return _bikeServices;
  }
  AirServices._internal();

  Future<List<AirQualityModel>> listAirStation() async {
    List<AirQualityModel> airQualityModels = <AirQualityModel>[];
    var uri = Uri.parse(ApiPath.air);
    try {
      Response rsp;
      rsp = await Dio().getUri(uri);
      // print(rsp.data);
      airQualityModels.add(AirQualityModel.fromJson(rsp.data));
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch air data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch air data $e');
    }

    return airQualityModels;
  }

  Future<AirIndexModel> getAirIndices(String stationId) async {
    late AirIndexModel airIndexModel;
    var uri = Uri.parse(ApiPath.air);
    try {
      Response rsp;
      rsp = await Dio().getUri(uri);
      // print(rsp.data);
      airIndexModel = AirIndexModel.fromJson(rsp.data);
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch air data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch air data $e');
    }

    return airIndexModel;
  }
}
