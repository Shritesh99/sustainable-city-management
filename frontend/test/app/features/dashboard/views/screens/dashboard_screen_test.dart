import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/shared_components/selection_button.dart';
import 'package:sustainable_city_management/app/shared_components/today_text.dart';
import 'package:sustainable_city_management/app/shared_components/chatting_card.dart';
// import 'package:sustainable_city_management/app/shared_components/responsive_builder.dart';

void main() {
  group('DashboardScreen', () {
    late DashboardController controller;

    setUp(() {
      controller = Get.put(DashboardController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('should render without crashing', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(
        home: DashboardScreen(),
      ));
    });

    testWidgets('should display the correct UI elements', (tester) async {
      await tester.pumpWidget(const GetMaterialApp(
        home: DashboardScreen(),
      ));

      expect(find.byType(SelectionButton), findsNothing);
      expect(find.byType(TodayText), findsOneWidget);
      //Mobile
      expect(find.byType(ChattingCard), findsNothing);
    });

    testWidgets('should open the sidebar when menu icon is tapped',
        (tester) async {
      await tester.pumpWidget(const GetMaterialApp(
        home: DashboardScreen(),
      ));

      expect(controller.scaffoldKey.currentState!.isDrawerOpen, isFalse);
      expect(find.byIcon(EvaIcons.menu), findsOneWidget);

      await tester.tap(find.byIcon(EvaIcons.menu));

      await tester.pumpAndSettle();

      expect(controller.scaffoldKey.currentState!.isDrawerOpen, isTrue);
    });
  });
}
