import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bin_truck_screen.dart';

void main() {
  testWidgets('BinTruckScreen widget tree is created properly',
      (WidgetTester tester) async {
    // Build the BinTruckScreen widget
    // await tester.pumpWidget(const MaterialApp(home: BinTruckScreen()));

    // // Check if GoogleMap is present in the widget tree
    // expect(find.byType(GoogleMap), findsOneWidget);

    // // Check if the initial camera position is correct
    // final googleMap = tester.widget<GoogleMap>(find.byType(GoogleMap));
    // expect(
    //     googleMap.initialCameraPosition.target,
    //     equals(const LatLng(
    //         53.342686, -6.267118))); // Replace with your expected LatLng
    // expect(googleMap.initialCameraPosition.zoom,
    //     equals(15.0)); // Replace with your expected zoom level
  });
}
