import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constans/aqi_level_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_index_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_station_model.dart';
import 'package:sustainable_city_management/app/services/air_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/shared_components/text_card.dart';

class AirScreen extends StatelessWidget {
  const AirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AirMapScreen();
  }
}

class _AirMapScreen extends StatefulWidget {
  @override
  State<_AirMapScreen> createState() => _AirMapScreenState();
}

class _AirMapScreenState extends State<_AirMapScreen> {
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;

  List<AirStation> airStations = <AirStation>[];
  final AirServices airService = AirServices();
  final Set<Marker> _markers = {};
  final Map<String, AqiData> _aqiData = {};
  final colorMap = <String, Color>{};
  final iconMap = <String, BitmapDescriptor>{};

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await addCustomMarker();
    listAirStations();
  }

  void listAirStations() async {
    await airService.listAirStation().then((value) => setState(() {
          airStations = value;
        }));
    addMarker();
  }

  Future<void> addCustomMarker() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.GOOD)
        .then((icon) => setState(() {
              iconMap[AqiLevel.GOOD] = icon;
              colorMap[AqiLevel.GOOD] = const Color(0xFF118b53);
            }));
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.MODERATE)
        .then((icon) => setState(() {
              iconMap[AqiLevel.MODERATE] = icon;
              colorMap[AqiLevel.MODERATE] = const Color(0xFFffd928);
            }));
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.UNHEALTHY_SENSITIVE)
        .then((icon) => setState(() {
              iconMap[AqiLevel.UNHEALTHY_SENSITIVE] = icon;
              colorMap[AqiLevel.UNHEALTHY_SENSITIVE] = const Color(0xFFfd8628);
            }));
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.UNHEALTHY)
        .then((icon) => setState(() {
              iconMap[AqiLevel.UNHEALTHY] = icon;
              colorMap[AqiLevel.UNHEALTHY] = const Color(0xFFbd0027);
            }));
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.VERY_UNHEALTHY)
        .then((icon) => setState(() {
              iconMap[AqiLevel.VERY_UNHEALTHY] = icon;
              colorMap[AqiLevel.VERY_UNHEALTHY] = const Color(0xFF520087);
            }));
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), AqiLevelIcon.HAZARDOUS)
        .then((icon) => setState(() {
              iconMap[AqiLevel.HAZARDOUS] = icon;
              colorMap[AqiLevel.HAZARDOUS] = const Color(0xFF69001a);
            }));
  }

  void addPopup(String stateId) {
    AqiData aqiData = _aqiData[stateId]!;
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
                            decoration: BoxDecoration(
                              color: colorMap[getState(aqiData.aqi)],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(0)),
                            ),
                            // color: backgroundColor,
                            child: Center(child: Text("AQI: ${aqiData.aqi}")),
                          ),
                          TextContainer(
                              text: aqiData.stationName,
                              textColor: Colors.black87,
                              backgroundColor: const Color(0xFFEEEEEE),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          // Container(
                          //   color: Color.fromARGB(255, 228, 228, 228),
                          //   alignment: Alignment.centerLeft,
                          //   child: Text.rich(TextSpan(children: [
                          //     const WidgetSpan(
                          //         child: Padding(
                          //             padding: EdgeInsets.only(left: 8.0))),
                          //     TextSpan(
                          //         text: aqiTest.epa,
                          //         style: const TextStyle(
                          //             color: Colors.black87,
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w600))
                          //   ])),
                          // ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: aqiData.getIndices(),
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 14))
                                ]))
                              ])),
                        ]),
                  )
                ])),
        LatLng(aqiData.latitude, aqiData.longitude));
  }

  String getState(int aqi) {
    if (aqi > 300) {
      return AqiLevel.HAZARDOUS;
    } else if (aqi >= 201) {
      return AqiLevel.VERY_UNHEALTHY;
    } else if (aqi >= 151) {
      return AqiLevel.UNHEALTHY;
    } else if (aqi >= 101) {
      return AqiLevel.UNHEALTHY_SENSITIVE;
    } else if (aqi >= 51) {
      return AqiLevel.MODERATE;
    } else {
      return AqiLevel.GOOD;
    }
  }

  void addMarker() {
    for (AirStation station in airStations) {
      int aqi = station.aqi;

      airService
          .getAirIndices(station.stationId)
          .then((aqiData) => {_aqiData[station.stationId] = aqiData});

      _markers.add(Marker(
        markerId: MarkerId(station.stationId),
        position: LatLng(station.latitude, station.longitude),
        icon: iconMap[getState(aqi)]!,
        onTap: () {
          addPopup(station.stationId);
        },
      ));
    }
  }

  List<Widget> getAqiPanel() {
    return colorMap.entries
        .map((e) => TextContainer(
              text: e.key,
              textColor: Colors.white,
              backgroundColor: e.value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // addMarker();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality'),
        backgroundColor: const Color.fromRGBO(29, 22, 70, 1),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            myLocationButtonEnabled: false,
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            (top, left, width, height) => null,
            controller: _customInfoWindowController,
            height: 160,
            width: 255,
            offset: 30,
          ),
          // aqi panel
          Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .01,
                  bottom: MediaQuery.of(context).size.height * .05),
              child: Container(
                height: MediaQuery.of(context).size.height * .3,
                width: (defaultTargetPlatform == TargetPlatform.android ||
                        defaultTargetPlatform == TargetPlatform.iOS)
                    ? MediaQuery.of(context).size.width * .3
                    : MediaQuery.of(context).size.width * .1,
                child: Card(
                    color: Colors.white,
                    elevation: 4.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: getAqiPanel(),
                    )),
              ))
        ],
      ),
    );
  }
}
