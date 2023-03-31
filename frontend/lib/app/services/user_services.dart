import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constans/app_constants.dart';
import '../dashboard/models/login_model.dart';
import '../dashboard/models/roles_model.dart';
import 'local_storage_services.dart';

final LocalStorageServices localStorageServices = LocalStorageServices();

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
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';

    try {
      Response rsp;
      rsp = await dio.post(ApiPath.login, data: reqData);
      print(rsp.data);
      loginResp = LoginModel.fromJson(rsp.data);
    } on DioError catch (e) {
      debugPrint('DioError: failed to login $e');
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
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    var token = await getToken();
    if (token != null) {
      dio.options.headers['Token'] = token;
      Response rsp;
      rsp = await dio.post(ApiPath.logout, data: reqData);
      print(rsp.data);
      await localStorageServices.delete("user");
    }
  }

  // get roles from API
  Future<List<RolesDatum>> getRolesFromApi() async {
    List<RolesDatum> rolesList = <RolesDatum>[];
    var uri = Uri.parse(ApiPath.getRoles);
    try {
      Response rsp;
      rsp = await Dio().getUri(uri);
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
    var auths = await LocalStorageServices().read("auths");
    if (auths == null) return null;
    return auths.split(',');
  }

  //get user profile from local storage
  Future<LoginModel?> getUserProfile() async {
    var profileStr = await LocalStorageServices().read("user");
    if (profileStr == null) return null;
    LoginModel profile = loginModelFromJson(profileStr);
    return profile;
  }

  //get user role from local storage
  Future<RolesDatum?> getRole() async {
    var roleStr = await LocalStorageServices().read("role");
    if (roleStr == null) return null;
    RolesDatum role = rolesDatumFromJson(roleStr);
    return role;
  }

  //get token from from local storage
  Future<String?> getToken() async {
    var token = await LocalStorageServices().read("Token");
    var expires = await LocalStorageServices().read("expires");
    var now = DateTime.now().millisecondsSinceEpoch / 1000;
    if (expires == null || (double.parse(expires) < now)) {
      await localStorageServices.deleteAll();
      return null;
    }
    return token;
  }
}
