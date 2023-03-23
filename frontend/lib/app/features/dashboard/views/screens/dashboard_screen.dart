library dashboard;

import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:sustainable_city_management/app/constans/app_constants.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/screens/login_screen.dart';
import 'package:sustainable_city_management/app/shared_components/chatting_card.dart';

import 'package:sustainable_city_management/app/shared_components/responsive_builder.dart';

import 'package:sustainable_city_management/app/shared_components/project_card.dart';
import 'package:sustainable_city_management/app/shared_components/selection_button.dart';
import 'package:sustainable_city_management/app/shared_components/today_text.dart';
import 'package:sustainable_city_management/app/utils/helpers/app_helpers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//screens

import 'package:sustainable_city_management/app/features/dashboard/views/screens/login_screen.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/screens/bus_screen.dart';

import 'package:sustainable_city_management/app/features/dashboard/views/screens/bin_truck.dart';

// binding
part '../../bindings/dashboard_binding.dart';

// controller
part '../../controllers/dashboard_controller.dart';

// models
part '../../models/profile_model.dart';

// component

part '../components/header.dart';
part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: _Sidebar(data: controller.getProfil()),
              ),
            ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 3)),
            _buildHeader(onPressedMenu: () => controller.openDrawer()),
            const SizedBox(height: kSpacing / 2),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    _buildHeader(onPressedMenu: () => controller.openDrawer()),
                    const SizedBox(height: kSpacing * 2),
                    const SizedBox(height: kSpacing),
                  ],
                ),
              ),
            ],
          );
        },
        // web
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 2 : 3,
                child: Column(
                  children: [
                    _Sidebar(data: controller.getProfil()),
                  ],
                ),
                // child: ClipRRect(
                //     borderRadius: const BorderRadius.only(
                //       topRight: Radius.circular(kBorderRadius),
                //       bottomRight: Radius.circular(kBorderRadius),
                //     ),
                //     child: Column(
                //       children: [
                //         _Sidebar(data: controller.getProfil()),
                //         const SizedBox(height: kSpacing * 2),
                //         const Divider(thickness: 10),
                //       ],
                //     )),
              ),
              Flexible(
                flex: 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing),
                    _buildHeader(),
                    const SizedBox(height: kSpacing * 2),
                    const SizedBox(height: kSpacing * 2),
                  ],
                ),
              ),
            ],
          );
        },
      )),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "menu",
              ),
            ),
          const TodayText(),
          // const Expanded(child: _Header()),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }
}
