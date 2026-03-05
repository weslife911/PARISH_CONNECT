import 'dart:convert';

String updateUserModelToJson(UpdateUserRequestModel data) =>
    json.encode(data.toJson());

class UpdateUserRequestModel {
  final String? fullName;
  final String? username;
  final String? email;
  final String? bio;
  final String? profilePic;
  final String? deanery;
  final String? parish;

  UpdateUserRequestModel({
    this.fullName,
    this.username,
    this.email,
    this.bio,
    this.profilePic,
    this.deanery,
    this.parish,
  });

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "username": username,
    "email": email,
    "bio": bio,
    "profile_pic": profilePic,
    "deanery": deanery,
    "parish": parish,
  };
}
