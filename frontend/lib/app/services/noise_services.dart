import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/dashboard/models/noise_model.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';

class NoiseServices {
  static final NoiseServices _noiseServices = NoiseServices._internal();
  static final UserServices userServices = UserServices();
  // static Dio dioClient = DioClient().dio;

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
}
