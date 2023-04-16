import 'package:get/get.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bus_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/air_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bike_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/login_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bin_truck_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/shared_components/screen_layout.dart';

part 'app_routes.dart';

/// contains all configuration pages
class AppPages {
  /// when the app is opened, this page will be the first to be shown
  // static const initial = Routes.dashboard;
  static const dashboard = Routes.dashboard;
  static const bike = Routes.bike;
  static const air = Routes.air;
  static const bus = Routes.bus;

  static const login = Routes.login;

  static final routes = [
    GetPage(
      name: _Paths.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(name: _Paths.login, page: () => LoginScreen()),
    GetPage(
      name: _Paths.bike,
      page: () => const BikeScreen(),
    ),
    GetPage(name: _Paths.air, page: () => const AirScreen()),
    GetPage(name: _Paths.bin_truck, page: () => const BinTruckScreen()),
    GetPage(name: _Paths.bus, page: () => const BusScreen()),
  ];
}
