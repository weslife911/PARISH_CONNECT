

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
    final String password;
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
        required this.password,
        this.bio,
        this.profilePic,
        this.role,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["_id"],
        fullName: json["full_name"],
        username: json["username"],
        email: json["email"],
        deanery: json["deanery"],
        parish: json["parish"],
        password: json["password"],
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
