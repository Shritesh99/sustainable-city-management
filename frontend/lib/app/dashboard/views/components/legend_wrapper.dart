import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LegendWrapper extends StatelessWidget {
  final List<Widget> textCards;

  const LegendWrapper({
    super.key,
    required this.textCards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .01,
            bottom: MediaQuery.of(context).size.height * .05),
        child: Container(
          height: MediaQuery.of(context).size.height * .3,
          width: (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS)
              ? MediaQuery.of(context).size.width * .3
              : MediaQuery.of(context).size.width * .1,
          child: Card(
              color: Colors.white,
              elevation: 4.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: textCards,
              )),
        ));
  }
}
