part of app_constants;

/// all endpoint api
class ApiPath {
  static const _BASE_URL = "https://scm-backend.rxshri99.live";
  // static const _BASE_URL = "http://127.0.0.1:8000";
  static const _LOCALHOST = "http://127.0.0.1:8000";

  static const login = "$_BASE_URL/gateway/login";
  static const logout = "$_BASE_URL/gateway/logout";
  static const register = "$_BASE_URL/gateway/register";
  static const getRoles = "$_BASE_URL/gateway/getRoles";

  static const bike =
      "https://api.jcdecaux.com/vls/v3/stations?apiKey=frifk0jbxfefqqniqez09tw4jvk37wyf823b5j1i&contract=dublin";

  static const airStation = "$_BASE_URL/gateway/getDetailedAirData";

  static const airIndex = "$_BASE_URL/gateway/getAirStation";

  static const bus = '$_BASE_URL/gateway/getBusDataByRouteId';
}
