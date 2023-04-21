import 'package:flutter/material.dart';

class OffsetPopupMenuButton<T> extends StatefulWidget {
  final List<PopupMenuItem<T>> itemList;
  const OffsetPopupMenuButton({super.key, required this.itemList})
      : assert(itemList.length != 0);
  @override
  State<OffsetPopupMenuButton> createState() => _OffsetPopupMenuButtonState();
}

class _OffsetPopupMenuButtonState<T> extends State<OffsetPopupMenuButton<T>> {
  Widget _offsetPopup() => PopupMenuButton<T>(
        itemBuilder: (context) => widget.itemList,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 50.0,
                width: 50.0,
                child: _offsetPopup())));
  }
}
