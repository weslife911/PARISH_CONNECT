import 'dart:convert';

String updateUserModelToJson(UpdateUserModel data) =>
    json.encode(data.toJson());

class UpdateUserModel {
  final String fullName;
  final String username;
  final String email;
  final String deanery;
  final String parish;
  final String? bio;
  final String? profilePic;

  UpdateUserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.deanery,
    required this.parish,
    this.bio,
    this.profilePic,
  });

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "username": username,
    "email": email,
    "deanery": deanery,
    "parish": parish,
    "bio": bio ?? "",
    "profile_pic": profilePic ?? "",
  };
}
