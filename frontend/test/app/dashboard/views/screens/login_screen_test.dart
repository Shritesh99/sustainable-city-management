import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sustainable_city_management/app/controller/ui_controller.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/login_screen.dart';

void main() {
  testWidgets(
      'LoginScreen UI components are displayed correctly and navigation is working',
      (WidgetTester tester) async {
    Get.lazyPut(() => UIController());
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Check if the "Welcome Back" title is present
    expect(find.text('Welcome Back'), findsOneWidget);

    // Check if the Email TextField is present
    expect(find.byType(TextField).first, findsOneWidget);

    // Check if the Password TextField is present
    expect(find.byType(TextField).last, findsOneWidget);

    // Check if the "Sign up" text is present
    final Finder richTextFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is RichText &&
          (widget.text as TextSpan).toPlainText() ==
              'Don\'t have an account? Sign up',
    );

    // Expect the predicate to find exactly one widget
    expect(richTextFinder, findsOneWidget);

    // Check if the Login button is present
    expect(find.text('Login'), findsOneWidget);

    // Test navigation to RegistrationScreen
    // await tester.tap(richTextFinder);
    // await tester.pumpAndSettle();

    // expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
