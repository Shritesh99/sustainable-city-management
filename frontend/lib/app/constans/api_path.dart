part of app_constants;

/// all endpoint api
class ApiPath {
  static const _BASE_URL = "https://scm-backend.rxshri99.live";
  static const _LOCALHOST = "http://127.0.0.1";

  static const login = "$_BASE_URL/gateway/login";
  static const logout = "$_BASE_URL/gateway/logout";
  static const getRoles = "$_BASE_URL/gateway/getRoles";

  static const bike =
      "https://api.jcdecaux.com/vls/v3/stations?apiKey=frifk0jbxfefqqniqez09tw4jvk37wyf823b5j1i&contract=dublin";

  static const airStation = "$_BASE_URL/gateway/getDetailedAirData";

  static const airIndex = "$_BASE_URL/gateway/getAirStation";
}
