import 'app/config/routes/app_pages.dart';
import 'app/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/shared_components/app_menu.dart';
import 'app/shared_components/split_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MyApp();
  }
}

class _MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<_MyApp> {
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
    return ProviderScope(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sustainable City Management',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        getPages: AppPages.routes,
        initialRoute: isLogin ? AppPages.dashboard : AppPages.login,
      ),
    );
  }
}
