import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/features/dashboard/models/air_quality_model.dart';
import 'package:sustainable_city_management/app/utils/services/air_services.dart';

import '../components/custom_info_window.dart';

class AirScreen extends StatelessWidget {
  const AirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AirMapScreen();
  }
}

class _AirMapScreen extends StatefulWidget {
  @override
  State<_AirMapScreen> createState() => _AirMapScreenState();
}

class _AirMapScreenState extends State<_AirMapScreen> {
  final AirServices airService = AirServices();
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 15.0;
  List<AirQualityModel> airQualityModels = <AirQualityModel>[];
  final Set<Marker> _markers = {};

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    getAirIndices();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  void getAirIndices() async {
    await airService.listAirStation().then((value) => setState(() {
          setState(() {
            airQualityModels = value;
          });
        }));

    print("come to the end");
  }

  void addMarkers() {
    for (var aqm in airQualityModels) {
      BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
      int aqi = aqm.aqiData.aqi;
      if (aqi > 300) {
        BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
                "assets/images/air_scale/hazardous.png")
            .then((icon) => markerIcon = icon);
      } else if (aqi >= 201) {
        BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
                "assets/images/air_scale/very_unhealthy.png")
            .then((icon) => markerIcon = icon);
      } else if (aqi >= 151) {
        BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
                "assets/images/air_scale/unhealthy.png")
            .then((icon) => markerIcon = icon);
      } else if (aqi >= 101) {
        BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
                "assets/images/air_scale/unhealthy_for_sensitive_groups.png")
            .then((icon) => markerIcon = icon);
      } else if (aqi >= 51) {
        BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
                "assets/images/air_scale/moderate.png")
            .then((icon) => markerIcon = icon);
      } else if (aqi >= 0) {
        BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(), "assets/images/air_scale/good.png")
            .then((icon) => markerIcon = icon);
      }

      _markers.add(Marker(
        markerId: MarkerId(aqm.aqiData.id.toString()),
        position: LatLng(aqm.aqiData.latitude, aqm.aqiData.longitude),
        icon: markerIcon,
        onTap: () {
          airService
              .getAirIndices(aqm.aqiData.stationId.toString())
              .then((airIndexModel) => {
                    _customInfoWindowController.addInfoWindow!(
                        Container(
                          margin: const EdgeInsets.all(20),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    blurRadius: 20,
                                    offset: Offset.zero,
                                    color: Colors.grey.withOpacity(0.5))
                              ]),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[]),
                        ),
                        LatLng(aqm.aqiData.latitude, aqm.aqiData.longitude))
                  });
        },
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
