import 'dart:convert';

import 'package:tasklyai/core/configs/formater.dart';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  String? user;
  String name;
  String description;
  String color;
  String? icon;
  String? status;
  DateTime startDate;
  DateTime endDate;
  int? progress;
  DateTime? createdAt;

  ProjectModel({
    this.user,
    required this.name,
    required this.description,
    required this.color,
    this.icon,
    this.status,
    required this.startDate,
    required this.endDate,
    this.progress,
    this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    user: json["user"],
    name: json["name"],
    description: json["description"],
    color: json["color"],
    icon: json["icon"],
    status: json["status"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    progress: json["progress"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "color": color,
    "startDate": Formatter.dateJson(startDate),
    "endDate": Formatter.dateJson(endDate),
  };
}
