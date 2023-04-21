import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constants/icon_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/bike_station_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/services/bike_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';

class BikeScreen extends StatelessWidget {
  const BikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _BikeMapScreen();
  }
}

class _BikeMapScreen extends StatefulWidget {
  @override
  State<_BikeMapScreen> createState() => _BikeMapScreenState();
}

class _BikeMapScreenState extends State<_BikeMapScreen> {
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;
  late BitmapDescriptor bikeIcon;
  List<BikeStationModel> bikeStations = <BikeStationModel>[];
  final Set<Marker> _markers = {};
  BikeServices bikeService = BikeServices();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    getBikeStation();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    addIcon();
  }

  Future<void> addIcon() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), BikeIcon.BIKE)
        .then((icon) => setState(() {
              bikeIcon = icon;
            }));
  }

  void getBikeStation() async {
    await bikeService.listBikeStation().then((value) => setState(() {
          bikeStations = value;
        }));
    addMarkers();
  }

  void addMarkers() {
    for (var bs in bikeStations) {
      _markers.add(Marker(
          markerId: MarkerId(bs.number.toString()),
          position: LatLng(bs.position.latitude, bs.position.longitude),
          icon: bikeIcon,
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
                                    bs.name,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                  ),
                                  Text(
                                    bs.address,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 8),
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: bs.mainStands.availabilities
                                                  .mechanicalBikes
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
                                              text: bs.mainStands.availabilities
                                                  .electricalBikes
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
                                              text: bs.mainStands.availabilities
                                                  .stands
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
              LatLng(bs.position.latitude, bs.position.longitude),
            );
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "Dublinbikes",
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
