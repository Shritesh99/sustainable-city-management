import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
//import 'package:google_maps_flutter_geojson/google_maps_flutter_geojson.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_model.dart';
import 'package:sustainable_city_management/google_maps_flutter_geojson.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_route_model.dart';
import 'package:sustainable_city_management/app/services/bus_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:collection/iterable_zip.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  State<BusScreen> createState() => BusScreenState();
}

CustomInfoWindowController _customInfoWindowController =
    CustomInfoWindowController();

// class CheckBoxExample extends StatefulWidget {
//   const CheckBoxExample({Key? key}) : super(key: key);

//   @override
//   State<CheckBoxExample> createState() => _CheckBoxExampleState();
// }

// class _CheckBoxExampleState extends State<CheckBoxExample> {
//   List multipleSelected = [];

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context)
      .loadString('/DublinBusMain.geojson');
  // .loadString('/DublinBus1.geojson'); //This is for the one line. testing.
  //.loadString('/DublinBus1.geojson'); // This is the original one.
}

Future<String> loadAsset2(BuildContext context) async {
  return await DefaultAssetBundle.of(context).loadString('/Station.geojson');
}

class BusScreenState extends State<BusScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> _markers = {};
  final BusServices BusService = BusServices();
  List<BusModel> ListBusModels = <BusModel>[];
  final Map<String, BusModel> _busData = {};

  List<BusModel> GettheBusList = [];
  final iconMap = <String, BitmapDescriptor>{};
  late BitmapDescriptor myIcon;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.34484562827169, -6.254833978649337),
    zoom: 14.4746,
  );
  get color => null;
  Set<Polyline> _polylineSet = Set<Polyline>();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // await addCustomMarker();
    // listBusStations('TEST');
  }

  void listBusStations(String routeId) async {
    await BusService.listBusState(routeId).then((value) => setState(() {
          ListBusModels = value;
        }));
    addMarker();
  }

  void addMarker() {
    List<Marker> listMarker = <Marker>[];

    for (BusModel station in ListBusModels) {
      String routeid = station.routeId;

      // This marker will be replaced after calling one job.
      listMarker.add(Marker(
        markerId: MarkerId(station.vehicleId),
        position: LatLng(station.latitude, station.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }
    setState(() => {_markers = listMarker.toSet()});
    //_markers.add(homeMarker);
  }
  //Put route id and get the routes.like a printinfo()
  //BusService.listBusState(UniqueRouteIds[index]);

  Polyline featureToGooglePolyline(List<dynamic> coordinates) {
    return Polyline(
        polylineId: PolylineId(Uuid().v4()),
        points: coordinates.map((x) => LatLng(x[1], x[0])).toList());
  }

  /*
  
  static const Marker schoolMarker = Marker(
      markerId: MarkerId('_schoolMarker'),
      infoWindow: InfoWindow(title: 'Trinity'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(53.34484562827169, -6.254833978649337));
*/
  String _iconImage = 'assets/images/' + 'bus_icon'.toString() + '.png';
  Future<void> addCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(7, 7)), 'assets/images/bus_icon.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  static const Marker homeMarker = Marker(
      markerId: MarkerId('_homeMarker'),
      infoWindow: InfoWindow(title: 'Home'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(53.3464062899053, -6.2570863424236));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        //He will give future job to the rendering page.
        future: loadAsset(context),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            String? geojson = snapshot.data;

            // This line below has an error.
            final layers =
                GeoJSONGoogleMapsResult.fromJson(jsonDecode(geojson!));

            //final getGeojsondata = GetJsonData.fromJson(geojson);

            final busRouteModel = busRouteModelFromJson(geojson);

            List<Feature> features = busRouteModel.features.toSet().toList();

            final uniqueString = features.toSet().toList();

            List<String> routeShortNameList = [];
            List<dynamic> routeCoordinatesList = [];
            List<String> routeIDList = [];
            for (int i = 0; i < uniqueString.length; i++) {
              //print(uniqueString[i].properties.routeShortName);
              routeShortNameList.add(uniqueString[i].properties.routeShortName);
              routeCoordinatesList.add(uniqueString[i].geometry.coordinates);
              routeIDList.add(uniqueString[i].properties.routeId);
            }

            var UniqueStrings = routeShortNameList.toSet().toList();
            // for (int i = 0; i < UniqueStrings.length; i++) {
            //   uniqueString[i].le
            // }

            //print(uniqueString[0]);
            final UniqueCoordinates = routeCoordinatesList.toSet().toList();
            //BusService.listBusState("2954_46038");#

            //BusService.listBusCoordinates('2954_46048');

            final UniqueRouteIds = routeIDList.toSet().toList();
            //BusService.listBusState("");
            // for (int i = 0; i < UniqueStrings.length; i++) {
            //   print(UniqueStrings[i]);
            //   print(UniqueRouteIds[i]);
            // }
            Map<String, Polyline> routeMap = {};

            for (int i = 0; i < UniqueStrings.length; i++) {
              //print(UniqueRouteIds[i]);
              List<LatLng> NewrouteCoordinatesList = [];
              for (int j = 0; j < UniqueCoordinates[i].length; j++) {
                //print(UniqueCoordinates[i][j][1].runtimeType);
                NewrouteCoordinatesList.add(LatLng(
                    UniqueCoordinates[i][j][1], UniqueCoordinates[i][j][0]));
              }
              routeMap[UniqueStrings[i]] = Polyline(
                  polylineId: PolylineId(UniqueStrings[i]),
                  points: NewrouteCoordinatesList,
                  width: 5,
                  color: Colors.green);
            }

            //Multiple Selection of the Bus route.

            // Map<String, String> CheckboxMapping = {};
            // List multipleSelected = [];
            // for (int i = 0; i < routeMap.length; i++) {}

            String StringUniqueStrings = UniqueStrings.toString();

            String StringUniqueCoordinates = UniqueCoordinates.toString();

            var latlong = StringUniqueStrings[0].split(",");
            // var latitude = parseFloat(latlong[0]);

            final Map<String, dynamic> combinedlist =
                Map.fromIterables(UniqueStrings, UniqueCoordinates);

            final StringCombinedlist = combinedlist.toString();

            bool isBool = false;
            bool _value = false;
            List<bool> checkBoxesCheckedStates = [false];

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
                  markers: _markers,
                  polylines: //Set<Polyline>.of([routeMap['69']!]),
                      _polylineSet,
                  // Set<Polyline>.of(layers
                  //     .polylines), // Show bus route gray color as a default

                  //Set<Polyline>.of(layers.polylines),
                  //polylines: //_polyline1,
                  //Set<Polyline>.of(UniqueCoordinates[0].polylines),

                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                endDrawer: Drawer(
                  child: ListView(padding: EdgeInsets.zero, children: [
                    Column(
                      children: List.generate(
                        UniqueStrings.length,
                        <Widget>(index) => CheckboxListTile(
                          title: Text(UniqueStrings[index]),
                          autofocus: false,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          value: UniqueStrings[index].isBool, //unchecked
                          selected: UniqueStrings[index].isBool,
                          onChanged: (bool? value) {
                            setState(() {
                              //UniqueStrings[index].isBool = value!;
                              _value = value!;
                              _polylineSet = Set<Polyline>.of(
                                  [routeMap[UniqueStrings[index]]!]);
                              listBusStations(UniqueRouteIds[index]);

                              //Calling marker
                              //BusService.listBusState(UniqueRouteIds[index]);
                              // I need to do, when I click the bus number,
                              // Not only shows the bus route but also shows current bus locations.
                              // which needs, mapping route id, route_short_name_coordinates and values(for checkbox)
                              // If I have a time....... (and Station?????)
                            });
                          },
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            );
          } else {
            return const Text("Loading......");
          }
        });
  }
}
