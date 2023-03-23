import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/features/dashboard/models/bike_station_Info.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/components/bike/map_pin_pill.dart';

class BikeScreen extends StatelessWidget {
  const BikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapScreen();
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);

    setMapPins();
  }

  BikeStationInfo currentlySelectedPin = BikeStationInfo(
      number: 42,
      stationName: "Hello World",
      stationAddr: "hello world",
      numOfBikeStands: 5,
      numOfMechanicalBike: 1,
      numOfElectricBike: 3,
      status: "open",
      lat: 53.342686,
      lng: -6.267118);
  double pinPillPosition = -100;
  // ToDo: add custom marker
  final Set<Marker> _markers = {};

  LatLng initialLocation = const LatLng(53.342686, -6.267118);

  void setMapPins() {
    _markers.add(
      Marker(
          markerId: MarkerId(currentlySelectedPin.number.toString()),
          position: initialLocation,
          onTap: () {
            setState(() {
              pinPillPosition = 0;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialLocation,
              zoom: 14,
            ),
            onMapCreated: onMapCreated,
            markers: _markers,
            onTap: (LatLng location) {
              setState(() {
                pinPillPosition = -100;
              });
            }),
        MapPinPill(
            pinPillPosition: pinPillPosition,
            currentlySelectedPin: currentlySelectedPin)
      ]),
    );
  }
}
