import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/register_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/login_screen.dart';

void main() {
  testWidgets(
      'LoginScreen UI components are displayed correctly and navigation is working',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Check if the "Welcome back" title is present
    expect(find.text('Welcome back'), findsOneWidget);

    // Check if the Email TextField is present
    expect(find.byType(TextField).first, findsOneWidget);

    // Check if the Password TextField is present
    expect(find.byType(TextField).last, findsOneWidget);

    // Check if the "Create Account?" text is present
    expect(find.text('Create Account?'), findsOneWidget);

    // Check if the Login button is present
    expect(find.text('Login'), findsOneWidget);

    // Test navigation to RegistrationScreen
    await tester.tap(find.text('Create Account?'));
    await tester.pumpAndSettle();

    expect(find.byType(RegistrationScreen), findsOneWidget);
  });
}
