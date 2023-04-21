import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constants/icon_level_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/noise_model.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';

class NoiseServices {
  static final NoiseServices _noiseServices = NoiseServices._internal();
  static final UserServices userServices = UserServices();

  factory NoiseServices({Dio? dio}) {
    if (_noiseServices._dioInstance == null) {
      _noiseServices._setDio(dio);
    }
    return _noiseServices;
  }
  NoiseServices._internal();
  Dio? _dioInstance;
  void _setDio(Dio? dio) {
    _dioInstance ??= dio ?? DioClient().dio;
  }

  Dio get dioClient => _dioInstance!;

  Future<List<NoiseDatum>> getNoiseData() async {
    var uri = Uri.parse(ApiPath.getNoiseData);
    Response rsp = await dioClient.getUri(uri);
    NoiseModel noiseModel = NoiseModel.fromJson(rsp.data);
    NoiseData noiseData = noiseModel.noiseData;
    return noiseData.noiseData;
  }

  Future<void> addCustomMarker(Map<String, Color> colorMap,
      Map<String, BitmapDescriptor> iconMap) async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), LaeqLevelIcon.VERY_LOW)
        .then((icon) {
      iconMap[LaeqLevel.VERY_LOW] = icon;
      colorMap[LaeqLevel.VERY_LOW] = const Color.fromARGB(255, 169, 211, 109);
    });

    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), LaeqLevelIcon.LOW)
        .then((icon) {
      iconMap[LaeqLevel.LOW] = icon;
      colorMap[LaeqLevel.LOW] = const Color.fromARGB(255, 5, 138, 56);
    });

    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), LaeqLevelIcon.MODERATE)
        .then((icon) {
      iconMap[LaeqLevel.MODERATE] = icon;
      colorMap[LaeqLevel.MODERATE] = const Color(0xFFffd928);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), LaeqLevelIcon.HIGH)
        .then((icon) {
      iconMap[LaeqLevel.HIGH] = icon;
      colorMap[LaeqLevel.HIGH] = const Color(0xFFfd8628);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), LaeqLevelIcon.VERY_HIGH)
        .then((icon) {
      iconMap[LaeqLevel.VERY_HIGH] = icon;
      colorMap[LaeqLevel.VERY_HIGH] = const Color(0xFFbd0027);
    });
  }

  String getState(double laeq) {
    if (laeq > 75) {
      return LaeqLevel.VERY_HIGH;
    } else if (laeq > 65 && laeq <= 75) {
      return LaeqLevel.HIGH;
    } else if (laeq > 55 && laeq <= 65) {
      return LaeqLevel.MODERATE;
    } else if (laeq > 45 && laeq <= 55) {
      return LaeqLevel.LOW;
    } else {
      return LaeqLevel.VERY_LOW;
    }
  }
}
