import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_info_window.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/air_screen.dart';

void main() {
  testWidgets('AirScreen widget tree is created properly',
      (WidgetTester tester) async {
    // Build the AirScreen widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: AirScreen(),
      ),
    ));

    // Find GoogleMap widget
    expect(find.byType(GoogleMap), findsOneWidget);

    // Find CustomInfoWindow widget
    expect(find.byType(CustomInfoWindow), findsOneWidget);

    // Find the AQI panel container and other containers
    expect(find.byType(Container), findsNWidgets(4));

    // Find the AppBar with the title 'Air Quality'
    expect(find.widgetWithText(AppBar, 'Air Quality'), findsOneWidget);

    // Pump the tester to handle pending timers before disposing of the widget tree
    await tester.pumpAndSettle();
  });
}
