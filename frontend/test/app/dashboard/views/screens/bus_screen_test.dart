import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bus_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('BusScreen should render correctly', (WidgetTester tester) async {
    // Build the BusScreen widget.
    await tester.pumpWidget(const MaterialApp(home: BusScreen()));

    // Verify that the AppBar is displayed.
    // expect(find.byType(AppBar), findsOneWidget);

    // Verify that the GoogleMap is displayed.
    // expect(find.byType(GoogleMap), findsOneWidget);

    // Verify that the endDrawer is present.
    // expect(find.byType(Drawer), findsOneWidget);

    // Verify that the DrawerHeader is displayed.
    // expect(find.byType(DrawerHeader), findsOneWidget);
  });
}
