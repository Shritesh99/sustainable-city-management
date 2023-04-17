import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bike_screen.dart';

void main() {
  testWidgets('BikeScreen widget tree is created properly',
      (WidgetTester tester) async {
    // Build the BikeScreen widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: BikeScreen(),
      ),
    ));

    // Find GoogleMap widget
    expect(find.byType(GoogleMap), findsOneWidget);

    // Find CustomInfoWindow widget
    expect(find.byType(CustomInfoWindow), findsOneWidget);

    // Find the AppBar with the title 'Dublinbikes'
    expect(find.widgetWithText(AppBar, 'Dublinbikes'), findsOneWidget);

    // Pump the tester to handle pending timers before disposing of the widget tree
    await tester.pumpAndSettle();
  });
}
