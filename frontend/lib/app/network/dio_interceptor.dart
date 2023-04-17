part of network;

class DioInterceptor extends Interceptor {
  final services = UserServices();

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await services.loadToken();
    options.headers['Token'] = token;
    options.headers['Content-Type'] = 'application/json';
    debugPrint('Dio: the request url are: ${options.uri}');
    debugPrint('Dio: the request headers are: ${options.headers}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    debugPrint('Dio: the response is: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    debugPrint('DioError: $err');
    super.onError(err, handler);
  }
}
