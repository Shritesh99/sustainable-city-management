// To parse this JSON data, do
//
//     final rolesModel = rolesModelFromJson(jsonString);

import 'dart:convert';

RolesModel loginModelFromMap(Map<String, dynamic> map) =>
    RolesModel.fromJson(map);

RolesModel rolesModelFromJson(String str) =>
    RolesModel.fromJson(json.decode(str));

String rolesModelToJson(RolesModel data) => json.encode(data.toJson());

RolesDatum rolesDatumFromMap(Map<String, dynamic> map) =>
    RolesDatum.fromJson(map);

RolesDatum rolesDatumFromJson(String str) =>
    RolesDatum.fromJson(json.decode(str));

String rolesDatumToJson(RolesDatum data) => json.encode(data.toJson());

class RolesModel {
  RolesModel({
    required this.error,
    required this.msg,
    required this.rolesData,
  });

  bool error;
  String msg;
  List<RolesDatum> rolesData;

  factory RolesModel.fromJson(Map<String, dynamic> json) => RolesModel(
        error: json["error"],
        msg: json["msg"],
        rolesData: List<RolesDatum>.from(
            json["roles_data"].map((x) => RolesDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
        "roles_data": List<dynamic>.from(rolesData.map((x) => x.toJson())),
      };
}

class RolesDatum {
  RolesDatum({
    required this.roleId,
    required this.roleName,
    required this.auths,
  });

  int roleId;
  String roleName;
  List<String> auths;

  factory RolesDatum.fromJson(Map<String, dynamic> json) => RolesDatum(
        roleId: json["role_id"],
        roleName: json["role_name"],
        auths: List<String>.from(json["auths"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "role_id": roleId,
        "role_name": roleName,
        "auths": List<dynamic>.from(auths.map((x) => x)),
      };
}
