// To parse this JSON data, do
//
//     final createParishRecordResponseModel = createParishRecordResponseModelFromJson(jsonString);

import 'dart:convert';

CreateParishRecordResponseModel createParishRecordResponseModelFromJson(String str) => CreateParishRecordResponseModel.fromJson(json.decode(str));

String createParishRecordResponseModelToJson(CreateParishRecordResponseModel data) => json.encode(data.toJson());

class CreateParishRecordResponseModel {
    bool success;
    String message;

    CreateParishRecordResponseModel({
        required this.success,
        required this.message,
    });

    factory CreateParishRecordResponseModel.fromJson(Map<String, dynamic> json) => CreateParishRecordResponseModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}