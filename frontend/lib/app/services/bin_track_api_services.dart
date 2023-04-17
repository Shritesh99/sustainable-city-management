import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/// contains all service to get data from Server
class BinTruckApiServices {
  static final BinTruckApiServices _binTruckApiServices =
      BinTruckApiServices._internal();

  factory BinTruckApiServices() {
    return _binTruckApiServices;
  }
  BinTruckApiServices._internal();

  final String apiKey = 'AIzaSyAKe5KBcPKIeCr29qUC3MD6fl3zw5NC3Ic';
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    return placeId;
  }

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=53.338046,-6.266340&destination=53.348046,-6.266340 &mode=driving&waypoints=optimize:true|via:53.338502142489865, -6.268629589583022|via:53.34069161088624, -6.2659004515648&key=$apiKey";
    //    "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=";
    http.Response response = await http.get(Uri.parse(url));
    Map values = convert.jsonDecode(response.body);
    return values["routes"][0]["overview_polyline"]["points"];
  }

  // to get data from server, you can use Http for simple feature
  // or Dio for more complex feature

  // Example:
  // Future<ProductDetail?> getProductDetail(int id)async{
  //   var uri = Uri.parse(ApiPath.product + "/$id");
  //   try {
  //     return await Dio().getUri(uri);
  //   } on DioError catch (e) {
  //     print(e);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
