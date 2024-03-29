import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/noise_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/legend_wrapper.dart';
import 'package:sustainable_city_management/app/services/noise_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/text_card.dart';

class NoiseScreen extends StatelessWidget {
  const NoiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _NoiseMapScreen();
  }
}

class _NoiseMapScreen extends StatefulWidget {
  @override
  State<_NoiseMapScreen> createState() => _NoiseMapScreenState();
}

class _NoiseMapScreenState extends State<_NoiseMapScreen> {
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 14.0;

  List<NoiseDatum> noiseMonitors = <NoiseDatum>[];
  final NoiseServices noiseServices = NoiseServices();
  final Set<Marker> _markers = {};
  final Map<String, NoiseDatum> _noiseData = {};
  final colorMap = <String, Color>{};
  final iconMap = <String, BitmapDescriptor>{};

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await noiseServices.addCustomMarker(colorMap, iconMap);
    getNoiseData();
  }

  // Obtain noise data from backend
  void getNoiseData() async {
    await noiseServices.getNoiseData().then((value) => setState(() {
          noiseMonitors = value;
        }));
    addMarker();
  }

  void addPopup(String stateId) {
    NoiseDatum noiseData = _noiseData[stateId]!;
    _customInfoWindowController.addInfoWindow!(
        Container(
            margin: const EdgeInsets.all(20),
            // height: 70,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      blurRadius: 10,
                      offset: Offset.zero,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: colorMap[
                                  noiseServices.getState(noiseData.laeq)],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(0)),
                            ),
                            // color: backgroundColor,
                            child: Center(
                                child: Text(
                                    "CURRENT RATING: ${noiseServices.getState(noiseData.laeq).toUpperCase()}")),
                          ),
                          TextContainer(
                            text: noiseData.location,
                            textColor: Colors.black87,
                            backgroundColor: const Color(0xFFEEEEEE),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 30,
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: noiseData.getIndices(),
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 14))
                                ]))
                              ])),
                        ]),
                  )
                ])),
        LatLng(noiseData.latitude, noiseData.longitude));
  }

  void addMarker() {
    debugPrint("iconMap: $iconMap");
    for (NoiseDatum monitor in noiseMonitors) {
      double laeq = monitor.laeq;
      _noiseData[monitor.monitorId.toString()] = monitor;
      _markers.add(Marker(
        markerId: MarkerId(monitor.monitorId.toString()),
        position: LatLng(monitor.latitude, monitor.longitude),
        icon: iconMap[noiseServices.getState(laeq)]!,
        onTap: () {
          addPopup(monitor.monitorId.toString());
        },
      ));
    }
  }

  List<Widget> getLaeqPanel() {
    return colorMap.entries
        .map((e) => TextContainer(
              text: e.key,
              textColor: Colors.white,
              backgroundColor: e.value,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // addMarker();
    return PageScaffold(
      title: 'Noise Level',
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
            height: 220,
            width: 255,
            offset: 30,
          ),
          // noise panel
          LegendWrapper(textCards: getLaeqPanel()),
        ],
      ),
    );
  }
}
