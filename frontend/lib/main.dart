import 'package:google_fonts/google_fonts.dart';
import 'package:sustainable_city_management/app/controller/ui_controller.dart';

import 'app/config/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/services/user_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

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
    await userServices.loadToken().then((token) => setState(() {
          if (token != '') isLogin = true;
        }));
  }

  @override
  void initState() {
    checkLogin();
    Get.put(UIController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sustainable City Management',
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xff00296b),
            primaryContainer: Color(0xffa0c2ed),
            secondary: Color(0xffd26900),
            secondaryContainer: Color(0xffffd270),
            tertiary: Color(0xff5c5c95),
            tertiaryContainer: Color(0xffc8dbf8),
            appBarColor: Color(0xffc8dcf8),
            error: null,
          ),
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 7,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            useM2StyleDividerInM3: true,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.ubuntuCondensed().fontFamily,
        ),
        getPages: AppPages.routes,
        initialRoute: isLogin ? AppPages.dashboard : AppPages.login,
      ),
    );
  }
}
