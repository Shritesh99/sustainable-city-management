import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_model.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import '../constants/app_constants.dart';
import '../dashboard/models/bus_model.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';

class BusServices {
  static final BusServices _busServices = BusServices._internal();
  static final UserServices userServices = UserServices();

  factory BusServices({Dio? dio}) {
    if (_busServices._dioInstance == null) {
      _busServices._setDio(dio);
    }
    return _busServices;
  }
  BusServices._internal();
  Dio? _dioInstance;
  void _setDio(Dio? dio) {
    _dioInstance ??= dio ?? DioClient().dio;
  }

  Dio get dioClient => _dioInstance!;

  Future<List<BusModel>> listBusState(String routeId) async {
    List<BusModel> NewBusModels = <BusModel>[];

    var uri = Uri.parse("${ApiPath.bus}?id=$routeId");
    Response rsp = await dioClient.getUri(uri);

    List<dynamic> busModels = rsp.data["bus_data"]["busData"] as List;
    for (var busmodel in busModels) {
      if (busmodel["routeID"] != null) {
        NewBusModels.add(BusModel.fromJson(busmodel));
      }
    }
    return NewBusModels;
  }
}
