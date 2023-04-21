import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_station_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/noise_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/pedestrian_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/services/noise_services.dart';
import 'package:sustainable_city_management/app/services/pedestrian_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_model.dart';
import 'package:sustainable_city_management/app/services/bin_truck_services.dart';
import 'package:sustainable_city_management/app/services/air_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/bike_station_model.dart';
import 'package:sustainable_city_management/app/services/bike_services.dart';

class PedestrianScreen extends StatelessWidget {
  const PedestrianScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PedestrianMapScreen();
  }
}

class _PedestrianMapScreen extends StatefulWidget {
  @override
  State<_PedestrianMapScreen> createState() => _PedestrianMapScreenState();
}

class _PedestrianMapScreenState extends State<_PedestrianMapScreen> {
  final LatLng _initialLocation = const LatLng(53.34973, -6.2609);
  final double _zoom = 16.0;
  double currentSliderValue = 0;
  bool isSliderDragging = true;
  bool _noiseIsPressed = false;
  bool _airIsPressed = false;
  //Data model List
  List<BikeStationModel> bikeStations = <BikeStationModel>[];
  List<PedestrianModel> pedestrianPositions = <PedestrianModel>[];
  List<BinPositionModel> binPositons = <BinPositionModel>[];
  List<AirStation> _airStations = <AirStation>[];
  List<NoiseDatum> noiseMonitors = <NoiseDatum>[];

  final Set<Marker> airMarkers = {};
  final Set<Marker> noiseMarkers = {};
  Set<Circle> _ppCircles = {};
  Set<Marker> _markers = {};

  final Map<String, BitmapDescriptor> iconMap = {};
  final Map<String, Color> colorMap = {};

  final AirServices airService = AirServices();
  final PedestrianServices pedestrianService = PedestrianServices();
  final BinTruckServices binTruckService = BinTruckServices();
  final BikeServices bikeService = BikeServices();
  final NoiseServices noiseServices = NoiseServices();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    getPedestrianPositions(0);
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await airService.addCustomMarker(iconMap, colorMap);
    await noiseServices.addCustomMarker(colorMap, iconMap);
    listAirStations();
    getNoiseData();
  }

  //Obtain pedestrian data from backend
  void getPedestrianPositions(int afterHour) async {
    await pedestrianService
        .getPedestrianByTime(afterHour)
        .then((value) => setState(() {
              pedestrianPositions = value;
            }));
    addPedestrianCircles();
  }

  void listAirStations() async {
    await airService.listAirStation(false).then((value) => setState(() {
          _airStations = value;
        }));
    addAirMarker();
  }

  void getNoiseData() async {
    await noiseServices.getNoiseData().then((value) => setState(() {
          noiseMonitors = value;
        }));
    addNoiseMarker();
  }

  void addPedestrianCircles() {
    Set<Circle> circles = {};
    for (var pp in pedestrianPositions) {
      circles.add(
        Circle(
          circleId: CircleId((pp.id + 1).toString()),
          center: LatLng(pp.latitude, pp.longitude),
          radius: sqrt(pp.amount / pi) * 5,
          fillColor: pedestrianService.getColorBasedOnAmt(pp.amount),
          strokeWidth: 0,
        ),
      );
    }
    setState(() {
      _ppCircles = circles;
    });
  }

  void addAirMarker() async {
    for (AirStation station in _airStations) {
      int aqi = station.aqi!;
      // add aqi data to pop up window
      airMarkers.add(Marker(
        markerId: MarkerId(station.stationId),
        position: LatLng(station.latitude, station.longitude),
        icon: iconMap[airService.getState(aqi)]!,
      ));
    }
  }

  void addNoiseMarker() {
    debugPrint("iconMap: $iconMap");
    for (NoiseDatum monitor in noiseMonitors) {
      double laeq = monitor.laeq;
      noiseMarkers.add(Marker(
        markerId: MarkerId(monitor.monitorId.toString()),
        position: LatLng(monitor.latitude, monitor.longitude),
        icon: iconMap[noiseServices.getState(laeq)]!,
      ));
    }
  }

  void _toggleMarkers() {}

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "Pedestrian",
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              if (!isSliderDragging) {
                _customInfoWindowController.onCameraMove!();
              }
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            myLocationButtonEnabled: false,
            markers: _markers,
            circles: _ppCircles,
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: _zoom,
            ),
          ),
          Positioned(
              top: 16,
              right: 16,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  control whether to display air data
                    FloatingActionButton(
                      onPressed: () {
                        debugPrint("FloatingActionButton1 be pressed");
                        setState(() {
                          _airIsPressed = !_airIsPressed;
                          if (_airIsPressed) {
                            setState(() {
                              _markers.addAll(airMarkers);
                              _markers = Set.from(_markers);
                            });
                          } else {
                            setState((() {
                              _markers = {};
                              if (_noiseIsPressed) {
                                _markers.addAll(noiseMarkers);
                              }
                            }));
                          }
                        });
                      },
                      backgroundColor:
                          _airIsPressed ? Colors.white60 : Colors.white,
                      elevation: 2,
                      child: const Icon(Icons.air),
                    ),
                    // control whether to display noise data
                    FloatingActionButton(
                      onPressed: () {
                        debugPrint("FloatingActionButton2 be pressed");
                        setState(() {
                          _noiseIsPressed = !_noiseIsPressed;
                          if (_noiseIsPressed) {
                            setState(() {
                              _markers.addAll(noiseMarkers);
                              _markers = Set.from(_markers);
                            });
                          } else {
                            setState(() {
                              _markers = {};
                              if (_airIsPressed) {
                                _markers.addAll(airMarkers);
                              }
                            });
                          }
                        });
                      },
                      backgroundColor:
                          _noiseIsPressed ? Colors.white60 : Colors.white,
                      elevation: 2,
                      child: const Icon(Icons.mic),
                    )
                  ])),
          Positioned(
              top: 16,
              left: 16,
              child: IgnorePointer(
                ignoring: false,
                child: Container(
                  width: 200,
                  color: Colors.white70,
                  child: Slider(
                    max: 3,
                    value: currentSliderValue,
                    divisions: 3,
                    label: currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentSliderValue = value;
                        getPedestrianPositions(value.round());
                      });
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
