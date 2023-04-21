import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constants/icon_level_constants.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/text_card.dart';
import 'package:sustainable_city_management/app/dashboard/models/bus_model.dart';
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
      .loadString('assets/DublinBusMain.geojson');
}

class BusScreenState extends State<BusScreen> {
  final Set<Marker> _markerList = {};
  final BusServices busService = BusServices();
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool isInitialized = true;
  List<BusModel> busModels = <BusModel>[];
  late BitmapDescriptor busIcon;
  Map<String, MapPolylineWrapper> routeMap = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(53.34484562827169, -6.254833978649337),
    zoom: 12,
  );
  get color => null;

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await addCustomMarker();
  }

  //obtain bus position from backend
  void listBusStations(String routeId, String busNumber, bool isRemove) async {
    await busService.listBusState(routeId).then((value) => setState(() {
          busModels = value;
        }));
    if (isRemove) {
      removeMarker();
    } else {
      addMarker(busNumber);
    }
  }

  Future<void> addCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), BusIcon.BUS_ICON)
        .then((value) => setState(() {
              busIcon = value;
            }));
  }

  void removeMarker() {
    List<Marker> listMarker = <Marker>[];

    for (BusModel station in busModels) {
      // This marker will be replaced after calling one job.
      listMarker.add(Marker(
        markerId: MarkerId(station.vehicleId),
        position: LatLng(station.latitude, station.longitude),
        icon: busIcon,
      ));
    }
    setState(() => {
          _markers = listMarker.toSet(),
          _markerList.removeAll(listMarker),
        });
  }

  void addMarker(String busNumber) {
    List<Marker> listMarker = <Marker>[];

    for (BusModel station in busModels) {
      // This marker will be replaced after calling one job.
      listMarker.add(Marker(
        markerId: MarkerId(station.vehicleId),
        position: LatLng(station.latitude, station.longitude),
        icon: busIcon,
        onTap: () => addPopup(station, busNumber),
      ));
    }
    setState(() => {
          _markers = listMarker.toSet(),
          _markerList.addAll(_markers),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        //He will give future job to the rendering page.
        future: loadAsset(context),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            String? geojson = snapshot.data;
            final busRouteModel = busRouteModelFromJson(geojson!);
            List<Feature> uniqueString =
                busRouteModel.features.toSet().toList();
            List<String> routeShortNameList = [];
            List<dynamic> routeCoordinatesList = [];
            List<String> routeIDList = [];

            for (int i = 0; i < uniqueString.length; i++) {
              routeShortNameList.add(uniqueString[i].properties.routeShortName);
              routeCoordinatesList.add(uniqueString[i].geometry.coordinates);
              routeIDList.add(uniqueString[i].properties.routeId);
            }

            var uniqueStringList = routeShortNameList.toSet().toList();
            final uniqueCoordinates = routeCoordinatesList.toSet().toList();
            final uniqueRouteIds = routeIDList.toSet().toList();

            for (int i = 0; i < uniqueStringList.length; i++) {
              List<LatLng> newRouteCoordinatesList = [];
              for (int j = 0; j < uniqueCoordinates[i].length; j++) {
                newRouteCoordinatesList.add(LatLng(
                    uniqueCoordinates[i][j][1], uniqueCoordinates[i][j][0]));
              }
              if (isInitialized) {
                routeMap[uniqueStringList[i]] = MapPolylineWrapper();
              }
              routeMap[uniqueStringList[i]]?.polyline = Polyline(
                  //consumeTapEvents: false,
                  polylineId: PolylineId(uniqueStringList[i]),
                  points: newRouteCoordinatesList,
                  width: 5,
                  color: Colors.green);
            }
            isInitialized = false;

            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return PageScaffold(
                title: 'BUS',
                body: Stack(children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: _initialPosition,
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
                        _markerList,
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
                          title: Text(uniqueStringList[index]),
                          activeColor: Colors.transparent,
                          checkColor: Colors.green,
                          value: routeMap[uniqueStringList[index]]!.value,
                          //multipleSelected[index],
                          onChanged: (value) {
                            setState(() => {
                                  if (_polylines.contains(
                                      routeMap[uniqueStringList[index]]!
                                          .polyline))
                                    {
                                      _polylines.remove(
                                          routeMap[uniqueStringList[index]]!
                                              .polyline),
                                      _markerList.remove((key, value) =>
                                          key == uniqueStringList[index]),
                                      _polylines = Set<Polyline>.of(_polylines),
                                      listBusStations(
                                          uniqueRouteIds[index], "", true),
                                      routeMap[uniqueStringList[index]]!.value =
                                          value!,
                                    }
                                  else
                                    {
                                      listBusStations(uniqueRouteIds[index],
                                          uniqueStringList[index], false),
                                      _polylines.add(
                                          routeMap[uniqueStringList[index]]!
                                              .polyline),
                                      _polylines = Set<Polyline>.of(_polylines),
                                      routeMap[uniqueStringList[index]]!.value =
                                          value!,
                                    }
                                });
                          },
                        ),
                      ),
                    )
                  ]),
                ),
              );
            });
          } else {
            return const Text("Loading......");
          }
        });
  }
}
