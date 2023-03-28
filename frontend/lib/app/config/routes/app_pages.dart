import 'package:sustainable_city_management/app/features/dashboard/views/screens/bus_screen.dart';

import '../../features/dashboard/views/screens/air_screen.dart';
import '../../features/dashboard/views/screens/dashboard_screen.dart';
import '../../features/dashboard/views/screens/bike_screen.dart';
import 'package:get/get.dart';
import '../../features/dashboard/views/screens/login_screen.dart';
import '../../features/dashboard/views/screens/bus_screen.dart';
import '../../features/dashboard/views/screens/bin_truck_screen.dart';
import '../../features/dashboard/views/screens/bus_screen.dart';
part 'app_routes.dart';

/// contains all configuration pages
class AppPages {
  /// when the app is opened, this page will be the first to be shown
  static const initial = Routes.dashboard;
  static const bike = Routes.bike;
  static const air = Routes.air;
  static const bus = Routes.bus;

  static final routes = [
    GetPage(
      name: _Paths.dashboard,
      page: () => const DashboardScreen(),
      //page: () => const LoginScreen(),

      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.bike,
      page: () => const BikeScreen(),
    ),
    GetPage(name: _Paths.air, page: () => const AirScreen()),
    GetPage(name: _Paths.bin_truck, page: () => const BinTruckScreen()),
    GetPage(name: _Paths.bus, page: () => const BusScreen()),
  ];
}
