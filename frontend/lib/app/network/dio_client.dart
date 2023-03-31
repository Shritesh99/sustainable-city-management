library network;

import 'package:dio/dio.dart';
import 'package:sustainable_city_management/app/services/local_storage_services.dart';
import 'package:flutter/foundation.dart';
part './dio_interceptor.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.interceptors.add(DioInterceptor());
  }

  Dio get dio => _dio;
}
