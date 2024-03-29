import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_index_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/air_station_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/legend_wrapper.dart';
import 'package:sustainable_city_management/app/services/air_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/page_scaffold.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/text_card.dart';

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
  bool _isPressed = false;
  final LatLng _initialLocation = const LatLng(53.342686, -6.267118);
  final double _zoom = 14.0;
  final AirServices airService = AirServices();

  List<AirStation> _airStations = <AirStation>[];
  Map<String, AqiData> _aqiData = {};
  Set<Marker> _markers = {};
  final colorMap = <String, Color>{};
  final iconMap = <String, BitmapDescriptor>{};
  bool _isFocastMode = false;

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
    await airService.addCustomMarker(iconMap, colorMap);
    _listAirStations();
  }

  void _toggleDataMode() {
    setState(() {
      _isFocastMode = !_isFocastMode;
    });
  }

  void _listAirStations() async {
    await airService.listAirStation(_isFocastMode).then((value) => setState(() {
          _airStations = value;
        }));
    addMarker();
  }

  void addPopup(String stateId) {
    AqiData aqiData = _aqiData[stateId]!;
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
                            decoration: BoxDecoration(
                              color: colorMap[airService.getState(aqiData.aqi)],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
                                  bottom: Radius.circular(0)),
                            ),
                            // color: backgroundColor,
                            child: Center(child: Text("AQI: ${aqiData.aqi}")),
                          ),
                          TextContainer(
                              text: aqiData.stationName,
                              textColor: Colors.black87,
                              backgroundColor: const Color(0xFFEEEEEE),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: aqiData.getIndices(),
                                      style: const TextStyle(
                                          color: Colors.black87, fontSize: 14))
                                ]))
                              ])),
                        ]),
                  )
                ])),
        LatLng(aqiData.latitude, aqiData.longitude));
  }

  void addMarker() async {
    Set<Marker> markers = {};
    Map<String, AqiData> aqiDataMap = {};
    for (AirStation station in _airStations) {
      int aqi = station.aqi!;
      // add aqi data to pop up window
      await airService
          .getAirIndices(station.stationId, _isFocastMode)
          .then((aqiData) => {aqiDataMap[station.stationId] = aqiData});

      markers.add(Marker(
        markerId: MarkerId(station.stationId),
        position: LatLng(station.latitude, station.longitude),
        icon: iconMap[airService.getState(aqi)]!,
        onTap: () {
          addPopup(station.stationId);
        },
      ));
    }
    setState(() {
      _markers = markers;
      _aqiData = aqiDataMap;
    });
  }

  List<Widget> getAqiPanel() {
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
    return PageScaffold(
      title: 'Air Quality',
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
            height: 160,
            width: 255,
            offset: 30,
          ),
          // add forcast button
          Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _toggleDataMode();
                    _listAirStations();
                    _isPressed = !_isPressed;
                  });
                },
                backgroundColor: _isPressed ? Colors.white60 : Colors.white,
                elevation: 2,
                child: const Icon(Icons.insights),
              )),
          // aqi panel
          LegendWrapper(textCards: getAqiPanel()),
        ],
      ),
    );
  }
}
