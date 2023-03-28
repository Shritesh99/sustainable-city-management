import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/features/dashboard/models/bike_station_model.dart';
import 'package:flutter/foundation.dart';
import '../../constans/app_constants.dart';

class BikeServices {
  static final BikeServices _bikeServices = BikeServices._internal();

  factory BikeServices() {
    return _bikeServices;
  }
  BikeServices._internal();

  // get bike stations detail from api
  Future<List<BikeStationModel>> listBikeStation() async {
    List<BikeStationModel> bikeStationModels = <BikeStationModel>[];
    var uri = Uri.parse(ApiPath.bike);
    try {
      Response rsp;
      rsp = await Dio().getUri(uri);
      for (var bs in (rsp.data as List)) {
        bikeStationModels.add(BikeStationModel.fromJson(bs));
      }
      return bikeStationModels;
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch bike data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch bike data $e');
    }

    return bikeStationModels;
  }
}
