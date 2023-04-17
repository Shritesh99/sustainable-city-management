// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromMap(Map<String, dynamic> map) =>
    LoginModel.fromJson(map);

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.token,
    required this.email,
    required this.error,
    required this.expires,
    required this.firstName,
    required this.lastName,
    required this.msg,
    required this.roleId,
    required this.userId,
  });

  String token;
  String email;
  bool error;
  int expires;
  String firstName;
  String lastName;
  String msg;
  int roleId;
  int userId;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["Token"],
        email: json["email"],
        error: json["error"],
        expires: json["expires"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        msg: json["msg"],
        roleId: json["roleId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "email": email,
        "error": error,
        "expires": expires,
        "firstName": firstName,
        "lastName": lastName,
        "msg": msg,
        "roleId": roleId,
        "userId": userId,
      };
}
