// To parse this JSON data, do
//
//     final returnResponseModel = returnResponseModelFromJson(jsonString);

import 'dart:convert';

ReturnResponseModel returnResponseModelFromJson(String str) => ReturnResponseModel.fromJson(json.decode(str));

String returnResponseModelToJson(ReturnResponseModel data) => json.encode(data.toJson());

class ReturnResponseModel {
    bool success;
    String message;

    ReturnResponseModel({
        required this.success,
        required this.message,
    });

    factory ReturnResponseModel.fromJson(Map<String, dynamic> json) => ReturnResponseModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
