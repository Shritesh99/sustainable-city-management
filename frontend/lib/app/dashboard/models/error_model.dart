// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

ErrorModel errorModelFromMap(Map<String, dynamic> str) =>
    ErrorModel.fromJson(str);

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
    required this.error,
    required this.msg,
  });

  bool error;
  String msg;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        error: json["error"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "msg": msg,
      };
}
