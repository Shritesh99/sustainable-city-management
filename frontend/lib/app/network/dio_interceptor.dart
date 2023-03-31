part of network;

class DioInterceptor extends Interceptor {
  final services = LocalStorageServices();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = services.read("Token");
    options.headers['Token'];
    options.headers['Content-Type'] = 'application/json';
    debugPrint('Dio: the request url are: ${options.uri}');
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
