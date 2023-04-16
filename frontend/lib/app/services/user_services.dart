import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/constans/localstorage_constants.dart';
import 'package:sustainable_city_management/app/shared_components/profile_card.dart';
import '../constans/app_constants.dart';
import '../dashboard/models/login_model.dart';
import '../dashboard/models/roles_model.dart';
import 'local_storage_services.dart';
import 'package:sustainable_city_management/app/network/dio_client.dart';
import 'package:sustainable_city_management/app/dashboard/models/error_model.dart';

final LocalStorageServices localStorageServices = LocalStorageServices();
final dioClient = DioClient().dio;

// User Account APIs
class UserServices {
  static final UserServices _userServices = UserServices._internal();

  factory UserServices() {
    return _userServices;
  }
  UserServices._internal();

  // login
  Future<LoginModel?> login(String username, String password) async {
    var reqData = {'username': username, 'password': password};
    LoginModel? loginResp = null;
    debugPrint("login reqData: $reqData");

    try {
      Response rsp = await dioClient.post(ApiPath.login, data: reqData);
      loginResp = LoginModel.fromJson(rsp.data);
      debugPrint("login rsp: $rsp");
    } on DioError catch (e) {
      Response? errorRsp = e.response;
      var errorModel = ErrorModel.fromJson(errorRsp!.data);
      loginResp = LoginModel(
          token: "",
          email: "",
          error: errorModel.error,
          expires: -1,
          firstName: "",
          lastName: "",
          msg: errorModel.msg,
          roleId: -1,
          userId: -1);
    } catch (e) {
      debugPrint('Error: failed to login $e');
    }
    if (loginResp != null) {
      List<RolesDatum> rolesList = await getRolesFromApi();
      for (var role in rolesList) {
        if (role.roleId == loginResp.roleId) {
          await localStorageServices.write(
              LocalStorageKey.ROLE, rolesDatumToJson(role));
          await localStorageServices.write(
              LocalStorageKey.AUTHS, role.auths.join(","));
        }
      }
      localStorageServices.write(
          LocalStorageKey.USER_INFO, loginModelToJson(loginResp));
    }
    return loginResp;
  }

  Future<void> logout() async {
    var userInfo = await localStorageServices.read(LocalStorageKey.USER_INFO);
    if (userInfo != '') {
      LoginModel userModel = loginModelFromJson(userInfo);
      var reqData = {'username': userModel.email};
      Response rsp;
      rsp = await dioClient.post(ApiPath.logout, data: reqData);
      print(rsp.data);
    }
    await localStorageServices.delete("user");
  }

  // get roles from API
  Future<List<RolesDatum>> getRolesFromApi() async {
    List<RolesDatum> rolesList = <RolesDatum>[];
    var uri = Uri.parse(ApiPath.getRoles);
    try {
      Response rsp = await dioClient.getUri(uri);
      var rolesResp = RolesModel.fromJson(rsp.data);
      rolesList = rolesResp.rolesData;
    } on DioError catch (e) {
      debugPrint('DioError: failed to fetch roles data $e');
    } catch (e) {
      debugPrint('Error: failed to fetch roles data $e');
    }
    return rolesList;
  }

  //get user auth from local storage
  Future<List<String>?> getAuths() async {
    var auths = await localStorageServices.read(LocalStorageKey.AUTHS);
    return auths.split(',');
  }

  Future<List<String>> loadAuths() async {
    var auths = await localStorageServices.read(LocalStorageKey.AUTHS);
    return auths.split(',');
  }

  //get user profile from local storage
  Future<LoginModel?> getUserProfile() async {
    var profileStr = await localStorageServices.read(LocalStorageKey.USER_INFO);
    LoginModel profile = loginModelFromJson(profileStr);
    return profile;
  }

  Future<ProfileCardData> loadProfileCardData() async {
    var profileStr = await localStorageServices.read(LocalStorageKey.USER_INFO);
    var roleStr = await localStorageServices.read(LocalStorageKey.ROLE);

    RolesDatum role = rolesDatumFromJson(roleStr);
    LoginModel userProfile = loginModelFromJson(profileStr);

    String username = '${userProfile.firstName}, ${userProfile.lastName}';
    String roleName = role.roleName;
    String email = userProfile.email;

    debugPrint("username: $username, roleName: $roleName, email: $email");

    return ProfileCardData(
        photo: const AssetImage(ImageRasterPath.avatarDefault),
        name: username,
        email: email,
        role: roleName);
  }

  //get user role from local storage
  Future<RolesDatum?> getRole() async {
    var roleStr = await localStorageServices.read(LocalStorageKey.ROLE);
    RolesDatum role = rolesDatumFromJson(roleStr);
    return role;
  }

  //get token from from local storage
  Future<String?> loadToken() async {
    var userInfo = await localStorageServices.read(LocalStorageKey.USER_INFO);
    var token;
    var expires;

    if (userInfo != '') {
      LoginModel userModel = loginModelFromJson(userInfo);
      token = userModel.token;
      expires = userModel.expires;
      var now = DateTime.now().millisecondsSinceEpoch / 1000;
      if (expires == null || (expires < now)) {
        await localStorageServices.deleteAll();
        return null;
      }
    }
    return token;
  }
}
