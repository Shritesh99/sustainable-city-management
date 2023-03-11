import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/constans/app_constants.dart';
import 'dart:developer' as developer;

class MessageBox extends StatelessWidget {
  MessageBox({this.onSearch, Key? key}) : super(key: key);

  final controller = TextEditingController();
  final Function(String value)? onSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          const SizedBox(height: kSpacing / 2),
          Padding(
            padding: const EdgeInsets.only(right: kSpacing),
            child: IconButton(
              onPressed: () {
                developer.log("press the message box!");
              },
              icon: const Icon(EvaIcons.menu),
              tooltip: "menu",
            ),
          ),
        ],
      ),
    );
  }
}
