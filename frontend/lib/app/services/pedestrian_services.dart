import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import 'package:sustainable_city_management/app/dashboard/models/pedestrian_model.dart';

final dioClient = DioClient().dio;

/// contains all service to get data from Server
class PedestrianServices {
  static final PedestrianServices _pedestrianServices =
      PedestrianServices._internal();

  factory PedestrianServices() {
    return _pedestrianServices;
  }
  PedestrianServices._internal();

  Future<List<PedestrianModel>> getPedestrianByTime(int afterHour) async {
    List<PedestrianModel> pedestrianModels = <PedestrianModel>[];
    var uri =
        Uri.parse(ApiPath.pedestrian + getTimestamp(afterHour).toString());
    try {
      Response rsp = await dioClient.getUri(uri);
      for (var p in (rsp.data['pedestrian_data']['pedestrianData'] as List)) {
        pedestrianModels.add(PedestrianModel.fromJson(p));
      }
      return pedestrianModels;
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch bins data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch bin data $e');
    }
    return pedestrianModels;
  }

  Color getColorBasedOnAmt(int amt) {
    if (amt > 5000) {
      return Colors.redAccent.withOpacity(0.5);
    } else if (amt > 3000) {
      return Colors.yellowAccent.withOpacity(0.4);
    } else {
      return Colors.greenAccent.withOpacity(0.3);
    }
  }

  int getTimestamp(int afterHour) {
    var now = DateTime.now().millisecondsSinceEpoch;
    var currentDate = DateTime.fromMillisecondsSinceEpoch(now);
    var marchDate = DateTime(currentDate.year, 3, 1);
    var marchWithHour = DateTime(marchDate.year, marchDate.month, 31,
        min(currentDate.hour + afterHour, 21));

    int res = marchWithHour.millisecondsSinceEpoch / 1000 as int;
    return res;
  }
}
