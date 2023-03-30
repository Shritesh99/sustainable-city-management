import 'package:flutter_test/flutter_test.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/screens/dashboard_screen.dart';

void main() {
  group('DashboardController', () {
    late DashboardController controller;

    setUp(() {
      controller = DashboardController();
    });

    test('should return profile data', () {
      final profileData = controller.getProfil();

      expect(profileData.name, equals('Pooki'));
      expect(profileData.email, equals('pooki@gmail.com'));
      expect(profileData.role, equals('City Manager'));
    });
  });
}
