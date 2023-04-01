import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/register_screen.dart';

void main() {
  testWidgets('RegistrationScreen renders form and its fields correctly',
      (WidgetTester tester) async {
    // Build the RegistrationScreen widget
    await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

    // Verify that the form is rendered
    expect(find.byType(Form), findsOneWidget);

    // Verify that the First Name field is rendered
    expect(find.widgetWithText(TextFormField, 'First Name'), findsOneWidget);

    // Verify that the Last Name field is rendered
    expect(find.widgetWithText(TextFormField, 'Last Name'), findsOneWidget);

    // Verify that the Email field is rendered
    expect(find.widgetWithText(TextFormField, 'youremail@email.com'),
        findsOneWidget);

    // Verify that the Password field is rendered
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

    // Verify that the Repeat Password field is rendered
    expect(
        find.widgetWithText(TextFormField, 'Repeat Password'), findsOneWidget);

    // Verify that the Role dropdown is rendered
    expect(find.text('Role'), findsOneWidget);

    // Verify that the Sign Up button is rendered
    expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
  });
}
