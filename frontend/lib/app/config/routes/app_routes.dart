part of 'app_pages.dart';

/// used to switch pages
class Routes {
  static const dashboard = _Paths.dashboard;
  static const login = _Paths.login;
  static const register = _Paths.register;
  //login
  //static const loginpage = _Paths.loginpage;
  static const bike = _Paths.bike;

  static const air = _Paths.air;
  static const bin_truck = _Paths.bin_truck;
  static const bus = _Paths.bus;
  static const pedestrian = _Paths.pedestrian;
}

/// contains a list of route names.
// made separately to make it easier to manage route naming
class _Paths {
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const register = '/register';

  static const bike = '/bike';
  static const bus = '/bus';
  static const air = '/air';
  static const bin_truck = '/bin_truck';
  static const pedestrian = '/pedestrian';
}
