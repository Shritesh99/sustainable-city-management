part of 'app_pages.dart';

/// used to switch pages
class Routes {
  static const dashboard = _Paths.dashboard;
  //login
  //static const loginpage = _Paths.loginpage;
  static const bike = _Paths.bike;
}

/// contains a list of route names.
// made separately to make it easier to manage route naming
class _Paths {
  static const dashboard = '/dashboard';
  //static const loginpage = '/loginpage';
  static const bike = '/bike';

  // Example :
  // static const index = '/';
  // static const splash = '/splash';
  // static const product = '/product';
}
