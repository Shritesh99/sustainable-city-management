import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/shared_components/page_scaffold.dart';

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

  Uint8List? markerImage;

  List<String> images = [
    ImageRasterPath.binIconPath,
  ];

  final List<Marker> _markers = [];
  List<LatLng> latlang = [
    const LatLng(53.34484562827169, -6.254833978649337),
    const LatLng(53.35186061923727, -6.267747047089646),
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < latlang.length; i++) {
      final Uint8List markerIcon =
          await getBytesFromAsset(images[0].toString(), 100);
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: latlang[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(snippet: 'Title of marker $i')));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "Bin Truck",
      body: GoogleMap(
        mapType: MapType.normal,
        // onTap: (LatLng latLng) {
        //   print('onTap: $latLng');
        // },
        markers: Set<Marker>.of(_markers),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
