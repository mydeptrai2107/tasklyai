// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String id;
  String email;
  String name;
  dynamic avatar;
  DateTime lastActive;
  DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.lastActive,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    avatar: json["avatar"],
    lastActive: DateTime.parse(json["lastActive"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "avatar": avatar,
    "lastActive": lastActive.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };
}
