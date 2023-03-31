import 'app/config/routes/app_pages.dart';
import 'app/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/services/user_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _myApp();
  }
}

class _myApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_myApp> {
  bool isLogin = false;

  final userServices = UserServices();

  void checkLogin() async {
    await userServices.getToken().then((token) => setState(() {
          if (token != null) isLogin = true;
        }));
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sustainable City Management',
      theme: AppTheme.basic,
      getPages: AppPages.routes,
      initialRoute: isLogin ? AppPages.dashboard : AppPages.login,
    );
  }
}
