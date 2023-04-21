import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constants/icon_constants.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/text_card.dart';
import 'package:uuid/uuid.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_model.dart';
import 'package:sustainable_city_management/google_maps_flutter_geojson.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_route_model.dart';
import 'package:sustainable_city_management/app/services/bus_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  State<BusScreen> createState() => BusScreenState();
}

CustomInfoWindowController _customInfoWindowController =
    CustomInfoWindowController();

class MapPolylineWrapper {
  late Polyline polyline;
  bool value = false;
}

Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context)
      .loadString('/DublinBusMain.geojson');
}

class BusScreenState extends State<BusScreen> {
  List multipleSelected = [];
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  //////////////////////////////////////////////////////////////////////////////////
  Set<Marker> _markers = {};
  //////////////////////////////////////////////////////////////////////////////////

  final BusServices BusService = BusServices();
  List<BusModel> ListBusModels = <BusModel>[];
  final Map<String, BusModel> _busData = {};

  List<BusModel> GettheBusList = [];
  final iconMap = <String, BitmapDescriptor>{};
  late BitmapDescriptor myIcon;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.34484562827169, -6.254833978649337),
    zoom: 12,
  );
  get color => null;
  Set<Polyline> _polylineSet = Set<Polyline>();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await addCustomMarker();
    // await addCustomMarker();
    // listBusStations('TEST');
  }

  //obtain bus position from backend
  void listBusStations(String routeId, String busNumber) async {
    await BusService.listBusState(routeId).then((value) => setState(() {
          ListBusModels = value;
        }));
    addMarker(busNumber);
  }

  void listBusStations2(String routeId) async {
    await BusService.listBusState(routeId).then((value) => setState(() {
          ListBusModels = value;
        }));
    removeMarker();
  }

  void removeMarker() {
    List<Marker> listMarker = <Marker>[];

    for (BusModel station in ListBusModels) {
      String routeid = station.routeId;

      // This marker will be replaced after calling one job.
      listMarker.add(Marker(
        markerId: MarkerId(station.vehicleId),
        position: LatLng(station.latitude, station.longitude),
        icon: icon,
      ));
    }
    setState(() => {
          _markers = listMarker.toSet(),
          _MarkerList.removeAll(listMarker),
        });
  }

  // Custom marker icon
  late BitmapDescriptor icon;

  Future<void> addCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), BusIcon.BUS_ICON)
        .then((value) => setState(() {
              icon = value;
            }));
  }

//directions_bus
//Everytime it get new marker, when click.
// so. Need to store the marker, until path is on.
  void addMarker(String busNumber) {
    List<Marker> listMarker = <Marker>[];

    for (BusModel station in ListBusModels) {
      // This marker will be replaced after calling one job.
      listMarker.add(Marker(
        markerId: MarkerId(station.vehicleId),
        position: LatLng(station.latitude, station.longitude),
        icon: icon,
        onTap: () => addPopup(station, busNumber),
      ));
    }
    setState(() => {
          _markers = listMarker.toSet(),
          _MarkerList.addAll(_markers),
        });
  }

  void addPopup(BusModel busModel, String busNumber) {
    _customInfoWindowController.addInfoWindow!(
        Container(
            margin: const EdgeInsets.all(20),
            // height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 10,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(0)),
                          ),
                          // color: backgroundColor,
                          child: Center(
                              child: Text("Route ID: ${busModel.routeId}")),
                        ),
                        TextContainer(
                          text: "Bus number: $busNumber",
                          textColor: Colors.black87,
                          backgroundColor: const Color(0xFFEEEEEE),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 30,
                        ),
                        TextContainer(
                          text: "Vechile Id: ${busModel.vehicleId}",
                          textColor: Colors.black87,
                          backgroundColor: const Color(0xFFFFFFFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 30,
                        ),
                      ],
                    ),
                  )
                ])),
        LatLng(busModel.latitude, busModel.longitude));
  }

  Polyline featureToGooglePolyline(List<dynamic> coordinates) {
    return Polyline(
        polylineId: PolylineId(Uuid().v4()),
        points: coordinates.map((x) => LatLng(x[1], x[0])).toList());
  }

  Set<Polyline> _polylines = {};
  Set<Marker> _MarkerList = {};
  // late Polyline polyline;
  List<BusModel> BusMarkersList = <BusModel>[];

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

            final UniqueCoordinates = routeCoordinatesList.toSet().toList();

            final UniqueRouteIds = routeIDList.toSet().toList();

            Map<String, MapPolylineWrapper> routeMap = {};

            for (int i = 0; i < UniqueStrings.length; i++) {
              List<LatLng> NewrouteCoordinatesList = [];
              for (int j = 0; j < UniqueCoordinates[i].length; j++) {
                NewrouteCoordinatesList.add(LatLng(
                    UniqueCoordinates[i][j][1], UniqueCoordinates[i][j][0]));
              }
              routeMap[UniqueStrings[i]] = MapPolylineWrapper();

              routeMap[UniqueStrings[i]]?.polyline = Polyline(
                  //consumeTapEvents: false,
                  polylineId: PolylineId(UniqueStrings[i]),
                  points: NewrouteCoordinatesList,
                  width: 5,
                  color: Colors.green);
            }

            return PageScaffold(
              title: 'BUS',
              body: Stack(children: <Widget>[
                GoogleMap(
                  initialCameraPosition: _kGooglePlex,
                  onTap: (position) {
                    _customInfoWindowController.hideInfoWindow!();
                  },
                  onCameraMove: (position) {
                    _customInfoWindowController.onCameraMove!();
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    _customInfoWindowController.googleMapController =
                        controller;
                  },
                  myLocationButtonEnabled: false,
                  markers: //_markers,
                      _MarkerList,
                  polylines: _polylines,
                ),
                CustomInfoWindow(
                  (top, left, width, height) => null,
                  controller: _customInfoWindowController,
                  height: 130,
                  width: 200,
                  offset: 30,
                ),
              ]),
              endDrawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
                  Column(
                    children: List.generate(
                      routeMap.length,
                      <Widget>(index) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.all(0),
                        dense: true,
                        title: Text(UniqueStrings[index]),
                        activeColor: Colors.transparent,
                        checkColor: Colors.green,
                        value: routeMap[UniqueStrings[index]]?.value,
                        //multipleSelected[index],
                        onChanged: (value) {
                          setState(() => {
                                routeMap[UniqueStrings[index]]?.value = value!,
                                if (_polylines.contains(
                                    routeMap[UniqueStrings[index]]!.polyline))
                                  {
                                    routeMap[UniqueStrings[index]]?.value =
                                        value!,
                                    multipleSelected.remove(
                                        routeMap[UniqueStrings[index]]?.value),
                                    routeMap[UniqueStrings[index]]?.value =
                                        value!,
                                    _polylines.remove(
                                        routeMap[UniqueStrings[index]]!
                                            .polyline),
                                    _MarkerList.remove((key, value) =>
                                        key == UniqueStrings[index]),
                                    _polylines = Set<Polyline>.of(_polylines),
                                    listBusStations2(UniqueRouteIds[index]),
                                  }
                                else
                                  {
                                    listBusStations(UniqueRouteIds[index],
                                        UniqueStrings[index]),
                                    multipleSelected.add(
                                        routeMap[UniqueStrings[index]]?.value),
                                    routeMap[UniqueStrings[index]]?.value =
                                        value!,
                                    _polylines.add(
                                        routeMap[UniqueStrings[index]]!
                                            .polyline),
                                    _polylines = Set<Polyline>.of(_polylines),
                                  }
                              });
                        },
                      ),
                    ),
                  )
                ]),
              ),
            );
          } else {
            return const Text("Loading......");
          }
        });
  }
}
