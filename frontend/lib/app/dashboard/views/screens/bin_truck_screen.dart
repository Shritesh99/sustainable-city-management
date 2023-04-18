import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/services/bin_truck_services.dart';
import 'package:sustainable_city_management/app/shared_components/page_scaffold.dart';

class BinTruckScreen extends StatelessWidget {
  const BinTruckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _BinTruckMapScreen();
  }
}

class _BinTruckMapScreen extends StatefulWidget {
  @override
  State<_BinTruckMapScreen> createState() => _BinTruckMapScreenState();
}

class _BinTruckMapScreenState extends State<_BinTruckMapScreen> {
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;
  List<BinPositionModel> binPositons = <BinPositionModel>[];
  final Set<Marker> _markers = {};
  BinTruckServices binTruckService = BinTruckServices();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    //getBinPositons();
    getTruckRoute();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  static const Polyline _kPolyline = Polyline(
      polylineId: PolylineId('_kPolyline'),
      points: [
        LatLng(53.254074732846284, -6.262206917109597),
        LatLng(53.42327222773603, -6.278387668190925),
      ],
      width: 5);
  void getTruckRoute() async {
    String points = "";
    await binTruckService.getRouteCoordinates().then((value) => setState(() {
          points = value;
        }));
  }

  void getBinPositons() async {
    await binTruckService.listBinPosition().then((value) => setState(() {
          binPositons = value;
        }));
    addMarkers();
  }

  void getRegionBinPositons(int region) async {
    await binTruckService
        .listRegionBinPosition(region)
        .then((value) => setState(() {
              binPositons = value;
            }));
    addMarkers();
  }

  void addMarkers() {
    for (var bp in binPositons) {
      String state = "unknow";
      if (bp.status == 0) {
        state = "empty";
      } else if (bp.status == 1) {
        state = "full";
      }
      _markers.add(Marker(
        markerId: MarkerId(bp.id.toString()),
        position: LatLng(bp.longitude, bp.latitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(snippet: 'Bin $state.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "BIN",
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
            polylines: {
              _kPolyline,
            },
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: _zoom,
            ),
          ),
          Drawer(
            width: 100,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
              ],
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
