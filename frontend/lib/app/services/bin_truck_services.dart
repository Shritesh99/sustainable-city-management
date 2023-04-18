import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_model.dart';

import 'dart:convert' as convert;

final dioClient = DioClient().dio;

/// contains all service to get data from Server
class BinTruckServices {
  static final BinTruckServices _binTruckApiServices =
      BinTruckServices._internal();

  factory BinTruckServices() {
    return _binTruckApiServices;
  }
  BinTruckServices._internal();

  final String apiKey = 'AIzaSyC92NVVdg26txxNpjy3ffDYIFX6TlQk2Mk';
  final dio = Dio();

  Future<String> getRouteCoordinates() async {
    // String url =
    //     "https://maps.googleapis.com/maps/api/directions/json?origin=53.338046,-6.266340&destination=53.348046,-6.266340&key=AIzaSyC92NVVdg26txxNpjy3ffDYIFX6TlQk2Mk";
    // http.Response response = await http.get(Uri.parse(url));
    // debugPrint(url);
    // debugPrint("what????");
    // Map values = convert.jsonDecode(response.body);
    // return values["routes"][0]["overview_polyline"]["points"];

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=53.338046,-6.266340&destination=53.348046,-6.266340&key=AIzaSyC92NVVdg26txxNpjy3ffDYIFX6TlQk2Mk";
    // var parsedUrl = Uri.parse(url);
    // Response response = await dio.get();
    Response response = await dio.get(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: {
        'origin': '53.338046,-6.266340',
        'destination': '53.348046,-6.266340',
        'key': 'AIzaSyC92NVVdg26txxNpjy3ffDYIFX6TlQk2Mk'
      },
    );
    var data = response.data;
    return data;

    // String url =
    //     "https://maps.googleapis.com/maps/api/directions/json?origin=53.338046,-6.266340&destination=53.348046,-6.266340 &key=AIzaSyC92NVVdg26txxNpjy3ffDYIFX6TlQk2Mk";
    // http.Response response = await http.get(url as Uri);
    // Map values = jsonDecode(response.body);
    // print("====================>>>>>>>>${values}");
  }

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
}
