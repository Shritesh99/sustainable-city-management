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
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final tokenProvider = FutureProvider<String?>((ref) async {
  return await UserServices().loadToken();
});

class InitialRouteHandler extends ConsumerWidget {
  const InitialRouteHandler({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(tokenProvider).when(
          data: (String? token) {
            if (token != null) {
              Get.offNamed(AppPages.dashboard);
            } else {
              Get.offNamed(AppPages.login);
            }
            return const SizedBox();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sustainable City Management',
      // theme: AppTheme.basic,

      theme: FlexThemeData.light(
        scheme: FlexScheme.tealM3,
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
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.tealM3,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useM2StyleDividerInM3: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),

      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,

      getPages: AppPages.routes,
      home: const InitialRouteHandler(),
    );
  }
}
