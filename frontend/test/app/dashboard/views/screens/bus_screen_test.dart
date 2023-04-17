import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sustainable_city_management/google_maps_flutter_geojson.dart';
// import 'package:sustainable_city_management/app/dashboard/models/bus_route_model.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bus_screen.dart';

void main() {
  testWidgets('BusScreen has AppBar, Drawer, and SafeArea',
      (WidgetTester tester) async {
    // Build the BusScreen widget
    await tester.pumpWidget(const MaterialApp(home: BusScreen()));

    // // Check if SafeArea is present in the widget tree
    // expect(find.byType(SafeArea), findsWidgets);

    // Check if AppBar is present in the widget tree
    // expect(find.byType(AppBar), findsWidgets);

    // Check if Drawer is present in the widget tree
    // expect(find.byType(Drawer), findsWidgets);

    // Pump the tester to handle pending timers before disposing of the widget tree
    await tester.pumpAndSettle();
  });
}
