import 'package:flutter/material.dart';

class TextContainer extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  const TextContainer({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Center(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor, fontSize: fontSize, fontWeight: fontWeight),
            ))));
  }
}
