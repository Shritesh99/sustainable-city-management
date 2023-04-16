library dashboard;

import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:sustainable_city_management/app/constans/app_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/login_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/roles_model.dart';
import 'package:sustainable_city_management/app/shared_components/chatting_card.dart';

import 'package:sustainable_city_management/app/shared_components/responsive_builder.dart';

import 'package:sustainable_city_management/app/shared_components/profile_card.dart';
import 'package:sustainable_city_management/app/shared_components/selection_button.dart';
import 'package:sustainable_city_management/app/shared_components/today_text.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/constans/auth_constants.dart';

// models
part '../../models/profile_model.dart';

// component

part '../components/header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _DashboardScreen();
  }
}

class _DashboardScreen extends StatefulWidget {
  @override
  State<_DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<_DashboardScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userServices = UserServices();
  List<String>? authList = <String>[];
  LoginModel? userProfile;
  ProfileCardData? profileCardData;
  RolesDatum? rolesModel;

  void openDrawer() {
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  void loadProfile() async {
    // read auths
    await userServices.getAuths().then((value) => setState(() {
          if (value != null) authList = value;
        }));
    debugPrint('authList: $authList');
    // read user profile
    await userServices.getUserProfile().then((value) => setState(() {
          if (value != null) userProfile = value;
        }));

    debugPrint('userProfile: $userProfile');

    // read user role information
    await userServices.getRole().then((value) => setState(() {
          if (value != null) rolesModel = value;
        }));

    debugPrint('rolesModel: $rolesModel');
    if (authList == null || userProfile == null || rolesModel == null) {
      Get.toNamed(Routes.login);
    }
  }

  // Profile Data
  ProfileCardData getProfil() {
    String username = "";
    String email = "";
    String roleName = "";
    if (userProfile != null) {
      username = userProfile!.firstName + "," + userProfile!.lastName;
      email = userProfile!.email;
    }

    if (rolesModel != null) {
      roleName = rolesModel!.roleName;
    }

    return ProfileCardData(
        photo: const AssetImage(ImageRasterPath.avatarDefault),
        name: username,
        email: email,
        role: roleName);
  }

  @override
  void initState() {
    // checkLogin();
    loadProfile();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: _Sidebar(
                  data: getProfil(),
                  auths: authList!,
                ),
              ),
            ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 3)),
            _buildHeader(onPressedMenu: () => openDrawer()),
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
                    _buildHeader(onPressedMenu: () => openDrawer()),
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
                    _Sidebar(
                      data: getProfil(),
                      auths: authList!,
                    ),
                  ],
                ),
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
