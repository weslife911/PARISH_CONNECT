import 'dart:convert';

String updateUserModelToJson(UpdateUserModel data) =>
    json.encode(data.toJson());

class UpdateUserModel {
  final String fullName;
  final String username;
  final String email;
  final String deanery; // Added
  final String parish; // Added
  final String? bio;
  final String? profilePic;

  UpdateUserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.deanery, // Added
    required this.parish, // Added
    this.bio,
    this.profilePic,
  });

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "username": username,
    "email": email,
    "deanery": deanery, // Added
    "parish": parish, // Added
    "bio": bio ?? "",
    "profile_pic": profilePic ?? "",
  };
}
