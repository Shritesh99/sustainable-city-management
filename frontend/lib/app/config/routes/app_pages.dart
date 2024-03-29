import 'package:get/get.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bus_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/air_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bike_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/bin_truck_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/login_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/noise_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/signup_screen.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/pedestrian_screen.dart';
part 'app_routes.dart';

/// contains all configuration pages
class AppPages {
  /// when the app is opened, this page will be the first to be shown
  // static const initial = Routes.dashboard;
  static const dashboard = Routes.dashboard;
  static const air = Routes.air;
  static const noise = Routes.noise;
  static const bike = Routes.bike;
  static const bus = Routes.bus;

  static const login = Routes.login;
  static const register = Routes.register;

  static final routes = [
    GetPage(name: _Paths.dashboard, page: () => const DashboardScreen()),
    GetPage(name: _Paths.login, page: () => const LoginScreen()),
    GetPage(name: _Paths.register, page: () => const SignUpScreen()),
    GetPage(name: _Paths.air, page: () => const AirScreen()),
    GetPage(name: _Paths.noise, page: () => const NoiseScreen()),
    GetPage(name: _Paths.bike, page: () => const BikeScreen()),
    GetPage(name: _Paths.bin_truck, page: () => const BinTruckScreen()),
    GetPage(name: _Paths.bus, page: () => const BusScreen()),
    GetPage(name: _Paths.pedestrian, page: () => const PedestrianScreen()),
  ];
}
