

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String fullName;
    final String username;
    final String email;
    final String password;
    final String? bio;
    final String? profilePic;
    final String? role;

    UserModel({
        required this.fullName,
        required this.username,
        required this.email,
        required this.password,
        this.bio,
        this.profilePic,
        this.role,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        fullName: json["full_name"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        bio: json["bio"],
        profilePic: json["profile_pic"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "username": username,
        "email": email,
        "password": password,
        "bio": bio,
        "profile_pic": profilePic,
        "role": role,
    };
}
