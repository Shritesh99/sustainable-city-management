import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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

    try {
      Response rsp = await dioClient.post(ApiPath.login, data: reqData);
      loginResp = LoginModel.fromJson(rsp.data);
    } on DioError catch (e) {
      // debugPrint('DioError: failed to login $e');
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
          await localStorageServices.write("role", rolesDatumToJson(role));
          await localStorageServices.write("auths", role.auths.join(","));
        }
      }
      localStorageServices.write("user", loginModelToJson(loginResp));
    }
    return loginResp;
  }

  Future<void> logout() async {
    var reqData = {'username': localStorageServices.read("username")};
    Response rsp;
    rsp = await dioClient.post(ApiPath.logout, data: reqData);
    print(rsp.data);
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
    var auths = await localStorageServices.read("auths");
    if (auths == null) return null;
    return auths.split(',');
  }

  //get user profile from local storage
  Future<LoginModel?> getUserProfile() async {
    var profileStr = await localStorageServices.read("user");
    if (profileStr == null) return null;
    LoginModel profile = loginModelFromJson(profileStr);
    return profile;
  }

  //get user role from local storage
  Future<RolesDatum?> getRole() async {
    var roleStr = await localStorageServices.read("role");
    if (roleStr == null) return null;
    RolesDatum role = rolesDatumFromJson(roleStr);
    return role;
  }

  //get token from from local storage
  Future<String?> getToken() async {
    var token = await localStorageServices.read("Token");
    var expires = await localStorageServices.read("expires");
    var now = DateTime.now().millisecondsSinceEpoch / 1000;
    if (expires == null || (double.parse(expires) < now)) {
      await localStorageServices.deleteAll();
      return null;
    }
    return token;
  }
}
