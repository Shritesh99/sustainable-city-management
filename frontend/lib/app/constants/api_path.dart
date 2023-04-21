part of app_constants;

/// all endpoint api
class ApiPath {
  static const _BASE_URL = "https://scm-backend.rxshri99.live";

  static const login = "$_BASE_URL/gateway/login";
  static const logout = "$_BASE_URL/gateway/logout";
  static const register = "$_BASE_URL/gateway/register";
  static const getRoles = "$_BASE_URL/gateway/getRoles";

  // static const bike =
  //     "https://api.jcdecaux.com/vls/v3/stations?apiKey=frifk0jbxfefqqniqez09tw4jvk37wyf823b5j1i&contract=dublin";
  static const bike = "https://scm-backend.rxshri99.live/gateway/getBikes";

  static const airStation = "$_BASE_URL/gateway/getDetailedAirData";
  static const airStationPredict = "$_BASE_URL/gateway/getPredictedAirStations";
  static const airIndex = "$_BASE_URL/gateway/getAirStation";

  static const bus = '$_BASE_URL/gateway/getBusDataByRouteId';
  static const allBins = "$_BASE_URL/gateway/getAllBins";
  static const regionBins = "$_BASE_URL/gateway/getBinsByRegion?region=";
  static const airIndexPredict =
      "$_BASE_URL/gateway/getPredictedDetailedAirData";
  static const pedestrian = "$_BASE_URL/gateway/getPedestrianByTime?time=";

  static const getNoiseData = "$_BASE_URL/gateway/getNoiseData";

  static const busRouteDirection =
      "https://maps.googleapis.com/maps/api/directions/json";
}
