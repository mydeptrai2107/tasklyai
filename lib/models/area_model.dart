// To parse this JSON data, do
//
//     final areaModel = areaModelFromJson(jsonString);

import 'dart:convert';

AreaModel areaModelFromJson(String str) => AreaModel.fromJson(json.decode(str));

String areaModelToJson(AreaModel data) => json.encode(data.toJson());

class AreaModel {
  String id;
  String userId;
  String name;
  String description;
  int color;
  int icon;
  int folderCount;
  int noteCount;
  int projectCount;

  AreaModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.folderCount,
    required this.noteCount,
    required this.projectCount,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
    id: json["_id"],
    userId: json["userId"],
    name: json["name"],
    description: json["description"],
    color: json["color"],
    icon: json["icon"],
    folderCount: json["folderCount"],
    noteCount: json["noteCount"],
    projectCount: json["projectCount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "name": name,
    "description": description,
    "color": color,
    "icon": icon,
    "folderCount": folderCount,
    "noteCount": noteCount,
    "projectCount": projectCount,
  };
}
