import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/shared_components/today_text.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Add this line
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  };

  testWidgets('DashboardScreen should render correctly',
      (WidgetTester tester) async {
    // Build the DashboardScreen widget.
    await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())));

    // Verify that the header is displayed.
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(TodayText), findsOneWidget);
  });
}
