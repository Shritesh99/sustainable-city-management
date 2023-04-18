import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/dashboard/models/noise_model.dart';
import '../constants/app_constants.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';

class NoiseServices {
  static final NoiseServices _noiseServices = NoiseServices._internal();
  static final dioClient = DioClient().dio;

  factory NoiseServices() {
    return _noiseServices;
  }
  NoiseServices._internal();

  Future<List<NoiseDatum>> getNoiseData() async {
    var uri = Uri.parse(ApiPath.getNoiseData);
    Response rsp = await dioClient.getUri(uri);
    NoiseModel noiseModel = NoiseModel.fromJson(rsp.data);
    NoiseData noiseData = noiseModel.noiseData;
    return noiseData.noiseData;
  }
}
