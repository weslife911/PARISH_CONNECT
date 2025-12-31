// To parse this JSON data, do
//
//     final checkAuthResponseModel = checkAuthResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:parish_connect/models/auth/user_model.dart';

CheckAuthResponseModel checkAuthResponseModelFromJson(String str) => CheckAuthResponseModel.fromJson(json.decode(str));

String checkAuthResponseModelToJson(CheckAuthResponseModel data) => json.encode(data.toJson());

class CheckAuthResponseModel {
    bool success;
    String? message;
    UserModel? user;

    CheckAuthResponseModel({
        required this.success,
        this.message,
        this.user,
    });

    factory CheckAuthResponseModel.fromJson(Map<String, dynamic> json) => CheckAuthResponseModel(
        success: json["success"],
        message: json["message"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user?.toJson(),
    };
}
