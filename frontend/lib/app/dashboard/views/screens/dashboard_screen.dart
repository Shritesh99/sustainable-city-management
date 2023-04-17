import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/shared_components/sidebar.dart';
import 'package:sustainable_city_management/app/shared_components/screen_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageBuilder = ref.watch(selectedPageBuilderProvider);

    return Scaffold(
      body: SplitView(
        menu: const AppMenu(),
        content: selectedPageBuilder(context),
      ),
    );
  }
}
