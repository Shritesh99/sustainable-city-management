import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BinTruckScreen extends StatefulWidget {
  const BinTruckScreen({Key? key}) : super(key: key);

  @override
  State<BinTruckScreen> createState() => BinTruckScreenState();
}

class BinTruckScreenState extends State<BinTruckScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.34484562827169, -6.254833978649337),
    zoom: 14.4746,
  );

  static const Marker schoolMarker = Marker(
      markerId: MarkerId('_schoolMarker'),
      infoWindow: InfoWindow(title: 'Trinity'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(53.34484562827169, -6.254833978649337));

  static const Marker homeMarker = Marker(
      markerId: MarkerId('_homeMarker'),
      infoWindow: InfoWindow(title: 'Home'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(53.35186061923727, -6.267747047089646));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          schoolMarker,
          homeMarker,
        },
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
