import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import 'package:sustainable_city_management/app/dashboard/models/pedestrian_model.dart';

final UserServices userServices = UserServices();
final dioClient = DioClient().dio;

/// contains all service to get data from Server
class PedestrianServices {
  static final PedestrianServices _pedestrianServices =
      PedestrianServices._internal();

  factory PedestrianServices() {
    return _pedestrianServices;
  }
  PedestrianServices._internal();

  Future<List<PedestrianModel>> getPedestrianByTime() async {
    List<PedestrianModel> pedestrianModels = <PedestrianModel>[];
    var uri = Uri.parse(ApiPath.pedestrian);
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
}
