part of network;

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await loadToken();
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

  //get token from from local storage
  Future<String?> loadToken() async {
    final services = LocalStorageServices();
    var userInfo = await services.read(LocalStorageKey.USER_INFO);
    var token;
    var expires;

    if (userInfo != '') {
      LoginModel userModel = loginModelFromJson(userInfo);
      token = userModel.token;
      expires = userModel.expires;
      var now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (expires == null || (expires < now)) {
        await services.deleteAll();
        return null;
      }
    }
    return token;
  }
}
