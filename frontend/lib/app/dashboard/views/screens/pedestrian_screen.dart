import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/pedestrian_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/services/pedestrian_services.dart';
import 'package:sustainable_city_management/app/shared_components/page_scaffold.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_model.dart';
import 'package:sustainable_city_management/app/services/bin_truck_services.dart';
import 'package:sustainable_city_management/app/services/air_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_index_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_station_model.dart';
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
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;

  List<BikeStationModel> bikeStations = <BikeStationModel>[];
  List<PedestrianModel> pedestrianPositions = <PedestrianModel>[];
  List<BinPositionModel> binPositons = <BinPositionModel>[];
  final Set<Marker> _markers = {};
  AirServices airService = AirServices();
  PedestrianServices pedestrianService = PedestrianServices();
  BinTruckServices binTruckService = BinTruckServices();
  BikeServices bikeService = BikeServices();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    getPedestrianPositions();
    getBikeStation();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void getPedestrianPositions() async {
    await pedestrianService.getPedestrianByTime().then((value) => setState(() {
          pedestrianPositions = value;
        }));
    addPedestrianMarkers();
  }

  void getBikeStation() async {
    await bikeService.listBikeStation().then((value) => setState(() {
          bikeStations = value;
        }));
    addBikeMarkers();
  }

  void addPedestrianMarkers() {
    for (var pp in pedestrianPositions) {
      String streetName = pp.streetName.toString();
      String amount = pp.amount.toString();

      _markers.add(Marker(
        markerId: MarkerId(pp.id.toString()),
        position: LatLng(pp.latitude, pp.longitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(snippet: '$streetName $amount.'),
      ));
    }
  }

  void addBikeMarkers() {
    for (var bs in bikeStations) {
      _markers.add(Marker(
          markerId: MarkerId(bs.number.toString()),
          position: LatLng(bs.position.latitude, bs.position.longitude),
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
      title: "Pedestrian",
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