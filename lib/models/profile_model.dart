// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

import 'package:tasklyai/core/network/dio_client.dart';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String id;
  String email;
  String name;
  String bio;
  dynamic avatar;
  DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.createdAt,
    required this.bio,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final avatar = json["avatarUrl"] == null
        ? ''
        : '$baseUrl${json["avatarUrl"]}';
    return ProfileModel(
      id: json["_id"],
      email: json["email"] ?? '',
      name: json["name"] ?? '',
      avatar: avatar,
      bio: json["bio"] ?? '',
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "name": name,
    "avatar": avatar,
    "createdAt": createdAt.toIso8601String(),
  };
}
