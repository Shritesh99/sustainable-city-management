import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/shared_components/today_text.dart';

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [const TodayText()],
    );
  }
}
