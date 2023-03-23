import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/features/dashboard/models/bike_station_Info.dart';

class MapPinPill extends StatefulWidget {
  double pinPillPosition;
  BikeStationInfo currentlySelectedPin;

  MapPinPill(
      {super.key,
      required this.pinPillPosition,
      required this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillState();
}

class MapPinPillState extends State<MapPinPill> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: const Duration(milliseconds: 400),
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
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
                                widget.currentlySelectedPin.stationName,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              Text(
                                widget.currentlySelectedPin.stationAddr,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 8),
                              ),
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: widget.currentlySelectedPin
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
                                          text: widget.currentlySelectedPin
                                              .numOfElectricBike
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
                                          text: widget.currentlySelectedPin
                                              .numOfBikeStands
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
              ))),
    );
  }
}

// class _TextWithIcon extends StatefulWidget {
//   String text;
//   Icon icon;

//   _TextWithIcon({required this.text, required this.icon});

//   @override
//   State<StatefulWidget> createState() => _TextWithIconState();
// }

// class _TextWithIconState extends State<_TextWithIcon> {
//   @override
//   Widget build(BuildContext context) {
//     return Text.rich(TextSpan(children: [
//       TextSpan(
//           text: widget.text,
//           style: const TextStyle(
//             color: Colors.black87,
//             fontSize: 20,
//           )),
//       const WidgetSpan(
//           child: Padding(
//         padding: EdgeInsets.only(left: 4.0),
//       )),
//       WidgetSpan(child: widget.icon),
//     ]));
//   }
// }
