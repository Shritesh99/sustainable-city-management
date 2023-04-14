import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';
import 'package:sustainable_city_management/app/constans/app_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/login_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/roles_model.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/shared_components/project_card.dart';

class SplitView extends StatelessWidget {
  const SplitView({
    Key? key,
    required this.menu,
    required this.content,
  }) : super(key: key);

  final Widget menu;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return _DashboardScreen(menu: menu, content: content);
  }
}

class _DashboardScreen extends StatefulWidget {
  final Widget menu;
  final Widget content;

  const _DashboardScreen({required this.menu, required this.content});

  @override
  State<_DashboardScreen> createState() =>
      _DashboardScreenState(menu: menu, content: content);
}

class _DashboardScreenState extends State<_DashboardScreen> {
  final Widget menu;
  final Widget content;

  _DashboardScreenState({required this.menu, required this.content});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final userServices = UserServices();
  List<String>? authList = <String>[];
  LoginModel? userProfile;
  ProfileCardData? profileCardData;
  RolesDatum? rolesModel;

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
    const int breakpoint = 600;
    const double menuWidth = 240;

    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= breakpoint) {
      // wide screen: menu on the left, content on the right
      return Row(
        children: [
          SizedBox(
            width: menuWidth,
            child: menu,
          ),
          Container(width: 0.5, color: Colors.black),
          Expanded(child: content),
        ],
      );
    } else {
      // narrow screen: show content, menu inside drawer
      return Scaffold(
        body: content,
        drawer: SizedBox(
          width: menuWidth,
          child: Drawer(
            child: menu,
          ),
        ),
      );
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
}
