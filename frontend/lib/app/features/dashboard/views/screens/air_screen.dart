import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/features/dashboard/models/air_station_model.dart';
import 'package:sustainable_city_management/app/utils/services/air_services.dart';

import '../components/custom_info_window.dart';

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

  BitmapDescriptor good = BitmapDescriptor.defaultMarker;
  BitmapDescriptor moderate = BitmapDescriptor.defaultMarker;
  BitmapDescriptor unhealthyForSensitive = BitmapDescriptor.defaultMarker;
  BitmapDescriptor unhealthy = BitmapDescriptor.defaultMarker;
  BitmapDescriptor veryUnhealthy = BitmapDescriptor.defaultMarker;
  BitmapDescriptor hazardous = BitmapDescriptor.defaultMarker;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    addCustomMarker();
    super.initState();
    listAirStations();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void listAirStations() async {
    AirServices airService = AirServices();
    await airService.listAirStation().then((value) => setState(() {
          airStations = value;
        }));
    addMarker();
  }

  void getAirIndices() async {
    await airService.listAirStation().then((value) => setState(() {
          setState(() {
            airStations = value;
          });
        }));

    print("come to the end");
  }

  void addCustomMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/air_scale/hazardous.png")
        .then((icon) => hazardous = icon);
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
            "assets/images/air_scale/very_unhealthy.png")
        .then((icon) => veryUnhealthy = icon);
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/air_scale/unhealthy.png")
        .then((icon) => unhealthy = icon);
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
            "assets/images/air_scale/unhealthy_for_sensitive_groups.png")
        .then((icon) => unhealthyForSensitive = icon);
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/air_scale/moderate.png")
        .then((icon) => moderate = icon);
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/air_scale/good.png")
        .then((icon) => setState(() {
              good = icon;
            }));
  }

  void addMarker() {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
    Color backgroundColor;
    for (AirStation station in airStations) {
      int aqi = station.aqi;
      if (aqi > 300) {
        markerIcon = hazardous;
        backgroundColor = const Color(0x0069001a);
      } else if (aqi >= 201) {
        markerIcon = veryUnhealthy;
        backgroundColor = const Color(0x00520087);
      } else if (aqi >= 151) {
        markerIcon = unhealthy;
        backgroundColor = const Color(0x00bd0027);
      } else if (aqi >= 101) {
        markerIcon = unhealthyForSensitive;
        backgroundColor = const Color(0x00fd8628);
      } else if (aqi >= 51) {
        markerIcon = moderate;
        backgroundColor = const Color(0x00ffd928);
      } else {
        markerIcon = good;
        backgroundColor = const Color(0x00118b53);
      }

      _markers.add(Marker(
        markerId: MarkerId(station.stationId),
        position: LatLng(station.latitude, station.longitude),
        icon: markerIcon,
        onTap: () {
          addPopup(station, backgroundColor);
        },
      ));
    }
  }

  void addPopup(AirStation station, Color backgroundColor) {
    _customInfoWindowController.addInfoWindow!(
        Container(
            margin: const EdgeInsets.all(20),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 20,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              color: backgroundColor,
                              child: Center(child: Text("AQI: ${station.aqi}")),
                            ),
                            const Expanded(child: Text("hello world"))
                          ]),
                    ),
                  )
                ])),
        LatLng(station.latitude, station.longitude));
    // airService.getAirIndices(station.stationId).then((aqiData) => {
    //       _customInfoWindowController.addInfoWindow!(
    //           Container(
    //               margin: const EdgeInsets.all(20),
    //               height: 70,
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: const BorderRadius.all(Radius.circular(20)),
    //                   boxShadow: <BoxShadow>[
    //                     BoxShadow(
    //                         blurRadius: 20,
    //                         offset: Offset.zero,
    //                         color: Colors.grey.withOpacity(0.5))
    //                   ]),
    //               child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Expanded(
    //                       child: Container(
    //                         margin: const EdgeInsets.only(left: 20),
    //                         child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: <Widget>[
    //                               DecoratedBox(
    //                                   decoration:
    //                                       BoxDecoration(color: backgroundColor),
    //                                   child: Text("AQI: ${aqiData.aqi}")),
    //                               const Expanded(child: Text("hello world"))
    //                             ]),
    //                       ),
    //                     )
    //                   ])),
    //           LatLng(aqiData.latitude, aqiData.longitude))
    //     });
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
            height: 130,
            width: 250,
            offset: 30,
          ),
        ],
      ),
    );
  }
}
