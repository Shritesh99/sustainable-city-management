import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/dashboard/models/bike_station_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';

class BikeServices {
  static final BikeServices _bikeServices = BikeServices._internal();
  static final UserServices userServices = UserServices();

  factory BikeServices({Dio? dio}) {
    if (_bikeServices._dioInstance == null) {
      _bikeServices._setDio(dio);
    }
    return _bikeServices;
  }

  BikeServices._internal();
  Dio? _dioInstance;
  void _setDio(Dio? dio) {
    _dioInstance ??= dio ?? DioClient().dio;
  }

  Dio get dioClient => _dioInstance!;

  // get bike stations detail from api
  Future<List<BikeStationModel>> listBikeStation() async {
    List<BikeStationModel> bikeStationModels = <BikeStationModel>[];
    var uri = Uri.parse(ApiPath.bike);
    try {
      Response rsp;
      rsp = await dioClient.getUri(uri);
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
