// To parse this JSON data, do
//
//     final createSccRecordResponseModel = createSccRecordResponseModelFromJson(jsonString);

import 'dart:convert';

CreateSccRecordResponseModel createSccRecordResponseModelFromJson(String str) => CreateSccRecordResponseModel.fromJson(json.decode(str));

String createSccRecordResponseModelToJson(CreateSccRecordResponseModel data) => json.encode(data.toJson());

class CreateSccRecordResponseModel {
    bool success;
    String message;

    CreateSccRecordResponseModel({
        required this.success,
        required this.message,
    });

    factory CreateSccRecordResponseModel.fromJson(Map<String, dynamic> json) => CreateSccRecordResponseModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
