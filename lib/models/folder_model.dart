import 'dart:convert';

FolderModel areaModelFromJson(String str) =>
    FolderModel.fromJson(json.decode(str));

String areaModelToJson(FolderModel data) => json.encode(data.toJson());

class FolderModel {
  String id;
  String userId;
  String areaId;
  String name;
  String description;
  int color;
  int icon;
  int noteCount;
  int projectCount;

  FolderModel({
    required this.id,
    required this.userId,
    required this.areaId,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.noteCount,
    required this.projectCount,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) => FolderModel(
    id: json["_id"],
    userId: json["userId"],
    areaId: json["areaId"],
    name: json["name"],
    description: json["description"],
    color: json["color"],
    icon: json["icon"],
    noteCount: json["noteCount"],
    projectCount: json["projectCount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "areaId": areaId,
    "name": name,
    "description": description,
    "color": color,
    "icon": icon,
  };
}
