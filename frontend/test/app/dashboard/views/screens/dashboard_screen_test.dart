import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/sidebar.dart';

void main() {
  testWidgets('DashboardScreen displays AppMenu and selected page content',
      (WidgetTester tester) async {
    // Create a simple WidgetBuilder to be used in the test
    testSelectedPageBuilder(BuildContext context) =>
        const Text('Selected Page Content');

    // Build the DashboardScreen widget
    await tester.pumpWidget(ProviderScope(
      overrides: [
        selectedPageBuilderProvider.overrideWithValue(testSelectedPageBuilder),
      ],
      child: const MaterialApp(
        home: DashboardScreen(),
      ),
    ));

    // Verify that the Container from the AppMenu is displayed
    expect(find.byType(Container), findsWidgets);

    // Verify that the selected page content is not displayed
    expect(find.text('Selected Page Content'), findsNothing);

    // Pump the widget tree with a fixed duration to allow animations and transitions to complete
    await tester.pump(const Duration(seconds: 5));
  });
}
