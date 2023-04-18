import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/pedestrian_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/services/pedestrian_services.dart';
import 'package:sustainable_city_management/app/shared_components/page_scaffold.dart';

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
  List<PedestrianModel> pedestrianPositions = <PedestrianModel>[];
  final Set<Marker> _markers = {};
  PedestrianServices pedestrianService = PedestrianServices();

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    getPedestrianPositions();
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
    addMarkers();
  }

  void addMarkers() {
    for (var bp in pedestrianPositions) {
      _markers.add(Marker(
        markerId: MarkerId(bp.id.toString()),
        position: LatLng(bp.longitude, bp.latitude),
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(snippet: '$bp.streetName $bp.amount.'),
      ));
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
