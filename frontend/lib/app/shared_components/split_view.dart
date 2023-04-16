import 'package:flutter/material.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.menu,
    required this.content,
  }) : super(key: key);

  final Widget menu;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    const int breakpoint = 600;
    const double menuWidth = 240;

    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      // wide screen: menu on the left, content on the right
      return Row(
        children: [
          SizedBox(
            width: menuWidth,
            child: menu,
          ),
          Container(width: 0.5, color: Colors.black),
          Expanded(child: content),
        ],
      );
    } else {
      // narrow screen: show content, menu inside drawer
      return Scaffold(
        body: content,
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            child: menu,
          ),
        ),
      );
    }
  }
}
