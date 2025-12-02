// user_model.dart (FIXED)

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String? id;
    final String fullName;
    final String username;
    final String email;
    final String deanery;
    final String parish;
    final String? password; // <--- MADE NULLABLE
    final String? bio;
    final String? profilePic;
    final String? role;

    UserModel({
      this.id,
        required this.fullName,
        required this.username,
        required this.email,
        required this.deanery,
        required this.parish,
        this.password, // <--- REMOVED 'REQUIRED'
        this.bio,
        this.profilePic,
        this.role,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["_id"],
        // Use ?? '' for fields that MUST be present on the model but might be null from the API
        fullName: json["full_name"] ?? '', // <--- ADDED NULL CHECK
        username: json["username"] ?? '',  // <--- ADDED NULL CHECK
        email: json["email"] ?? '',        // <--- ADDED NULL CHECK
        deanery: json["deanery"] ?? '',    // <--- ADDED NULL CHECK
        parish: json["parish"] ?? '',      // <--- ADDED NULL CHECK
        password: json["password"],        // Already nullable, no need for ?? ''
        bio: json["bio"],
        profilePic: json["profile_pic"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
      "_id": id,
        "full_name": fullName,
        "username": username,
        "email": email,
        "deanery": deanery,
        "parish": parish,
        "password": password,
        "bio": bio,
        "profile_pic": profilePic,
        "role": role,
    };
}