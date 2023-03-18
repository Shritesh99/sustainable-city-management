import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_geojson/google_maps_flutter_geojson.dart';

import '../../../../../google_maps_flutter_geojson.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({Key? key}) : super(key: key);

  @override
  State<BusScreen> createState() => BusScreenState();
}

Future<String> loadAsset(BuildContext context) async {
  return await DefaultAssetBundle.of(context)
      .loadString('assets/DublinBus1.geojson');
}

class BusScreenState extends State<BusScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(53.34484562827169, -6.254833978649337),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: loadAsset(context),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            String? geojson = snapshot.data;
            var layers = GeoJSONGoogleMapsResult.fromJson(jsonDecode(geojson!));

            // print(geojson);
            return Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                polygons: Set.of(layers.polygons),
                polylines: Set.of(layers.polylines),
                markers: Set.of(layers.markers),
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            );
          } else
            return Text("Loading...");
        });
  }
}
