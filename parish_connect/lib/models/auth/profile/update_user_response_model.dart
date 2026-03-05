import 'dart:convert';

UpdateUserResponseModel updateResponseModelFromJson(String str) =>
    UpdateUserResponseModel.fromJson(json.decode(str));

class UpdateUserResponseModel {
  final bool success;
  final String message;

  UpdateUserResponseModel({required this.success, required this.message});

  factory UpdateUserResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserResponseModel(
        success: json["success"] ?? false,
        message: json["message"] ?? "",
      );
}
