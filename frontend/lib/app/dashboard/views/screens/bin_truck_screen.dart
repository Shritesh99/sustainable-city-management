import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/constants/icon_level_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/bin_truck_direction_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/popup_menu.dart';
import 'package:sustainable_city_management/app/services/bin_truck_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';

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
  final iconMap = <String, BitmapDescriptor>{};
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;
  List<BinPositionModel> binPositons = <BinPositionModel>[];

  Set<Marker> _markers = {};
  Directions _route = Directions.nullReturn;
  BinTruckServices binTruckService = BinTruckServices();

  @override
  void initState() {
    super.initState();
    getBinPositons();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await addIcons();
  }

  Future<void> addIcons() async {
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), BinIcon.EMPTY_BIN)
        .then((icon) => setState(() {
              iconMap["empty"] = icon;
            }));
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), BinIcon.FULL_BIN)
        .then((icon) => setState(() {
              iconMap["full"] = icon;
            }));
  }

  //Obtain data from goole map api
  void getTruckRoute() async {
    await binTruckService
        .getRouteCoordinates(binPositons, "driving")
        .then((value) => setState(() {
              _route = value;
            }));
  }

  //get all bin data from backend
  void getBinPositons() async {
    await binTruckService.listBinPosition().then((value) => setState(() {
          binPositons = value;
        }));
    addMarkers();
  }

  //get regional bin data from api
  void getRegionBinPositons(int region) async {
    await binTruckService
        .listRegionBinPosition(region)
        .then((value) => setState(() {
              binPositons = value;
            }));

    addMarkers();
    getTruckRoute();
  }

  void addMarkers() {
    List<Marker> markerList = [];
    for (var bp in binPositons) {
      String icon = "empty";
      if (bp.status == 1) {
        icon = "full";
      }
      markerList.add(Marker(
        markerId: MarkerId(bp.id.toString()),
        position: LatLng(bp.latitude, bp.longitude),
        icon: iconMap[icon]!,
      ));
    }
    setState(() {
      _markers = markerList.toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: "BIN",
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            markers: _markers,
            polylines: {
              if (_route.polylinePoints.isNotEmpty)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.blue.shade500,
                  width: 5,
                  points: _route.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: _zoom,
            ),
          ),
          Positioned(
              top: 16,
              right: 16,
              child: OffsetPopupMenuButton<int>(
                itemList: List.generate(
                    7,
                    (index) => PopupMenuItem(
                          value: index + 1,
                          child: Text(
                            "Region ${index + 1}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          onTap: () {
                            getRegionBinPositons(index + 1);
                          },
                        )),
              )),
        ],
      ),
    );
  }
}
