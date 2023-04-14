import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/shared_components/app_menu.dart';
import 'package:sustainable_city_management/app/shared_components/split_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);

    return Scaffold(
      body: SplitView(
        menu: AppMenu(),
        content: selectedPageBuilder(context),
      ),
    );
  }
}
