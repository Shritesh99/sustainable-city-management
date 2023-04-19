import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/sidebar.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('Renders with AppMenu and selectedPageBuilder',
        (WidgetTester tester) async {
      // Create a mock selectedPageBuilder to pass into the DashboardScreen.
      mockSelectedPageBuilder(BuildContext context) => Container();

      // Create the test widget.
      final testWidget = MaterialApp(
        home: ProviderScope(
          overrides: [
            selectedPageBuilderProvider
                .overrideWithValue(mockSelectedPageBuilder),
          ],
          child: const DashboardScreen(),
        ),
      );

      // Render the test widget.
      await tester.pumpWidget(testWidget);

      // Verify that the AppMenu is present.
      expect(find.byType(AppMenu), findsOneWidget);

      // Verify that the selectedPageBuilder is present.
      expect(find.byType(Container), findsWidgets);
    });
  });
}
