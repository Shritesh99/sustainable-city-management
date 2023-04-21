import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constants/icon_constants.dart';
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

  Future<void> addCustomMarker(Map<String, BitmapDescriptor> iconMap,
      Map<String, Color> colorMap) async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.GOOD)
        .then((icon) {
      iconMap[AqiLevel.GOOD] = icon;
      colorMap[AqiLevel.GOOD] = const Color(0xFF118b53);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.MODERATE)
        .then((icon) {
      iconMap[AqiLevel.MODERATE] = icon;
      colorMap[AqiLevel.MODERATE] = const Color(0xFFffd928);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.UNHEALTHY_SENSITIVE)
        .then((icon) {
      iconMap[AqiLevel.UNHEALTHY_SENSITIVE] = icon;
      colorMap[AqiLevel.UNHEALTHY_SENSITIVE] = const Color(0xFFfd8628);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.UNHEALTHY)
        .then((icon) {
      iconMap[AqiLevel.UNHEALTHY] = icon;
      colorMap[AqiLevel.UNHEALTHY] = const Color(0xFFbd0027);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.VERY_UNHEALTHY)
        .then((icon) {
      iconMap[AqiLevel.VERY_UNHEALTHY] = icon;
      colorMap[AqiLevel.VERY_UNHEALTHY] = const Color(0xFF520087);
    });
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.HAZARDOUS)
        .then((icon) {
      iconMap[AqiLevel.HAZARDOUS] = icon;
      colorMap[AqiLevel.HAZARDOUS] = const Color(0xFF69001a);
    });
  }

  String getState(int aqi) {
    if (aqi > 300) {
      return AqiLevel.HAZARDOUS;
    } else if (aqi >= 201) {
      return AqiLevel.VERY_UNHEALTHY;
    } else if (aqi >= 151) {
      return AqiLevel.UNHEALTHY;
    } else if (aqi >= 101) {
      return AqiLevel.UNHEALTHY_SENSITIVE;
    } else if (aqi >= 51) {
      return AqiLevel.MODERATE;
    } else {
      return AqiLevel.GOOD;
    }
  }
}
