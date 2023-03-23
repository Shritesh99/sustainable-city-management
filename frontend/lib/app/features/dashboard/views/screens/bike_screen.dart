import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/components/bike/custom_info_window.dart';

import '../../models/bike_station_Info.dart';

class BikeScreen extends StatelessWidget {
  const BikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MapScreen();
  }
}

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;

  BikeStationInfo bikeStation = BikeStationInfo(
      number: 42,
      stationName: "Hello World",
      stationAddr: "hello world",
      numOfBikeStands: 5,
      numOfMechanicalBike: 1,
      numOfElectricBike: 3,
      status: "open",
      lat: 53.342686,
      lng: -6.267118);

  BikeStationInfo bikeStation2 = BikeStationInfo(
      number: 43,
      stationName: "Hello Hell",
      stationAddr: "hello hell",
      numOfBikeStands: 4,
      numOfMechanicalBike: 2,
      numOfElectricBike: 5,
      status: "open",
      lat: 53.342686,
      lng: -7.367118);

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId(bikeStation.number.toString()),
        position: LatLng(bikeStation.lat, bikeStation.lng),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Container(
                margin: const EdgeInsets.all(20),
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
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
                                Text(
                                  bikeStation.stationName,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  bikeStation.stationAddr,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 8),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: bikeStation
                                                .numOfMechanicalBike
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20,
                                            )),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 2.0),
                                        )),
                                        const WidgetSpan(
                                            child: Icon(Icons.directions_bike,
                                                color: Colors.black87)),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                        )),
                                        TextSpan(
                                            text: bikeStation.numOfElectricBike
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 20)),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 2.0),
                                        )),
                                        const WidgetSpan(
                                            child: Icon(Icons.electric_bike,
                                                color: Colors.black87)),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                        )),
                                        TextSpan(
                                            text: bikeStation.numOfBikeStands
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 20)),
                                        const WidgetSpan(
                                            child: Icon(Icons.local_parking,
                                                color: Colors.black87)),
                                      ])),
                                    ])
                              ],
                            )))
                  ],
                )),
            LatLng(bikeStation.lat, bikeStation.lng),
          );
        },
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId(bikeStation2.number.toString()),
        position: LatLng(bikeStation2.lat, bikeStation2.lng),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Container(
                margin: const EdgeInsets.all(20),
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
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
                                Text(
                                  bikeStation2.stationName,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  bikeStation2.stationAddr,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 8),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: bikeStation2
                                                .numOfMechanicalBike
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20,
                                            )),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 2.0),
                                        )),
                                        const WidgetSpan(
                                            child: Icon(Icons.directions_bike,
                                                color: Colors.black87)),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                        )),
                                        TextSpan(
                                            text: bikeStation2.numOfElectricBike
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 20)),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 2.0),
                                        )),
                                        const WidgetSpan(
                                            child: Icon(Icons.electric_bike,
                                                color: Colors.black87)),
                                        const WidgetSpan(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                        )),
                                        TextSpan(
                                            text: bikeStation2.numOfBikeStands
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 20)),
                                        const WidgetSpan(
                                            child: Icon(Icons.local_parking,
                                                color: Colors.black87)),
                                      ])),
                                    ])
                              ],
                            )))
                  ],
                )),
            LatLng(bikeStation2.lat, bikeStation2.lng),
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dublinbikes'),
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
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: LatLng(bikeStation.lat, bikeStation.lng),
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            (top, left, width, height) => null,
            controller: _customInfoWindowController,
            height: 130,
            width: 200,
            offset: 30,
          ),
        ],
      ),
    );
  }
}
