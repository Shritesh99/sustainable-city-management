import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_direction_model.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_model.dart';

final dioClient = DioClient().dio;
const String apiKey = 'AIzaSyC92NVVdg26txxNpjy3ffDYIFX6TlQk2Mk';
final dio = Dio();

/// contains all service to get data from Server
class BinTruckServices {
  static final BinTruckServices _binTruckApiServices =
      BinTruckServices._internal();

  factory BinTruckServices() {
    return _binTruckApiServices;
  }
  BinTruckServices._internal();

  Future<List<BinPositionModel>> listBinPosition() async {
    List<BinPositionModel> binPositionModels = <BinPositionModel>[];
    var uri = Uri.parse(ApiPath.allBins);
    try {
      Response rsp = await dioClient.getUri(uri);
      for (var bin in (rsp.data['bin_data']['bins'] as List)) {
        binPositionModels.add(BinPositionModel.fromJson(bin));
      }
      return binPositionModels;
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch bins data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch bin data $e');
    }
    return binPositionModels;
  }

  Future<List<BinPositionModel>> listRegionBinPosition(int region) async {
    List<BinPositionModel> binPositionModels = <BinPositionModel>[];
    var uri = Uri.parse(ApiPath.regionBins + region.toString());
    try {
      Response rsp = await dioClient.getUri(uri);
      for (var bin in (rsp.data['bin_data']['bins'] as List)) {
        binPositionModels.add(BinPositionModel.fromJson(bin));
      }
      return binPositionModels;
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch bins data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch bin data $e');
    }
    return binPositionModels;
  }

  Future<Directions> getRouteCoordinates(
      List<BinPositionModel> binModels, String mode) async {
    if (binModels.isEmpty) {
      return Directions.nullReturn;
    }
    List<BinPositionModel> modelsInOrder = extractFullBin(binModels);
    String waypointStr = appendWaypoints(modelsInOrder);

    String url =
        "${ApiPath.busRouteDirection}?$waypointStr&mode=$mode&key=$apiKey";
    Response rsp = await dio.get(url);

    return Directions.fromMap(rsp.data);
  }

  String appendWaypoints(List<BinPositionModel> binModels) {
    int endIdx = min(binModels.length - 1, 20);
    // get the origin (the first element) and the dest (the last)
    String uri =
        "origin=${binModels[0].latitude},${binModels[0].longitude}&destination=${binModels[endIdx].latitude},${binModels[endIdx].longitude}&waypoints=optimize:true";

    for (int i = 1; i < endIdx; i++) {
      uri += "|${binModels[i].latitude},${binModels[i].longitude}";
    }
    return uri;
  }

  List<BinPositionModel> extractFullBin(List<BinPositionModel> models) {
    List<BinPositionModel> newModels =
        models.where(((bin) => bin.status == 1)).toList();
    // reorder the binModels based on the latitude (low to height)
    newModels.sort((o1, o2) => o1.latitude.compareTo(o2.latitude));
    return newModels;
  }
}
