import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
//import 'package:google_maps_flutter_geojson/google_maps_flutter_geojson.dart';

import 'package:sustainable_city_management/google_maps_flutter_geojson.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_route_model.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  State<BusScreen> createState() => BusScreenState();
}

Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context).loadString('/test.json');
  // .loadString('/DublinBus1.geojson'); //This is for the one line. testing.
  //.loadString('/DublinBus1.geojson'); // This is the original one.
}

class BusScreenState extends State<BusScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.34484562827169, -6.254833978649337),
    zoom: 14.4746,
  );

  // static const Polyline myLine = Polyline(
  //     polylineId: PolylineId('_kPolyline'),
  //     points: [
  //       LatLng(-6.4202783, 53.2976017),
  //       LatLng(-6.4200189390546, 53.2978629619594),
  //       LatLng(-6.4199855, 53.2978967),
  //     ],
  //     width: 5);

  static const Marker homeMarker = Marker(
    markerId: MarkerId('_homeMarker'),
    infoWindow: InfoWindow(title: 'Home'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(-6.4199855, 53.2978967),
    //LatLng(-6.4202783, 53.2976017),
  );
// class GetJsonData {
//   String agency_name;
//   String route_short_name;

//   GetJsonData.fromJson(Map geojson)
//       : agency_name = json['agency_name'],
//         route_short_name = json['route_short_name'];

//   Map toJson() {
//     return {'agency_name': agency_name, 'route_short_name': route_short_name};
//   }
// }
// FutureBuilder : Let's say you want to fetch some data from the backend on page launch and show a loader until data comes.
// FutureBuilder : Give the async task in futre of FutureBuilder.
  bool isChecked = false;
  Polyline featureToGooglePolyline(List<dynamic> coordinates) {
    return Polyline(
        polylineId: PolylineId(Uuid().v4()),
        points: coordinates.map((x) => LatLng(x[1], x[0])).toList());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        //He will give future job to the rendering page.
        future: loadAsset(context),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            String? geojson = snapshot.data;
            Map<String, dynamic> routeMap = json.decode(geojson!);
            Set<Polyline> polylines = {};
            routeMap.values.forEach((element) {
              polylines
                  .add(featureToGooglePolyline(element["Coordinates"] as List));
            });
            // I got the geoJson data.
            // print(geojson);
            // This line below has an error.
            // final layers =
            //     GeoJSONGoogleMapsResult.fromJson(jsonDecode(geojson!));

            // final getGeojsondata = GetJsonData.fromJson(geojson);

            // Need to do something in GeoJSONGoogleMapResult.
            // Instance of 'GeoJSONGoogleMapsResult'
            // print(layers);
            // print(geojson);
            // print(geojson.runtimeType);

            // final busRouteModel = busRouteModelFromJson(geojson);

            // //List<Feature>
            // busRouteModel.features
            //     .forEach((element) => element.properties.routeShortName);

            //print(busRouteModel.features.runtimeType);
            // busRouteModel.features.forEach((element) => element.geometry.forEach((element2)=> element2.coordinates));

            // Map<String, dynamic> map = json.decode(geojson);
            //  print(layers.markers.length);
            return SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    body: GoogleMap(
                      mapType: MapType.normal,
                      //polygons: Set.of(layers.polygons),
                      //polylines: Set<Polyline>.of(layers.polylines),
                      polylines: polylines,
                      // Here is the algorithm that I want to use it.
                      // Collecting the 'route_short_name' into the list or dictionaray(?)
                      // becuase there is a lot of redundancy in data and If the number of What I choose, then show on the map.
                      //
                      // How to using a Property in here?

                      // Property: Set.of(layers.route_short_name),

                      // markers: Set.of(layers.markers),

                      markers: {
                        homeMarker,
                      },
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    endDrawer: Drawer(
                      child: ListView(padding: EdgeInsets.zero, children: [
                        const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text('Showing Bus, Tram list'
                              'Whenever click the bus, shows on the map'),
                        ),
                        CheckboxListTile(
                            title: Text('Bus 83'),
                            value: isChecked, //unchecked
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            }),
                        ListTile(
                          title: const Text('Bus 39A'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                    )));
          } else {
            return const Text("Loading......");
          }
        });
  }
}
