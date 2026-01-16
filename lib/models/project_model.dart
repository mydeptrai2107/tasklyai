// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  String id;
  String userId;
  String areaId;
  String name;
  String description;
  int color;
  int icon;
  DateTime startDate;
  DateTime endDate;
  bool hideCompleted;
  String energyLevel;
  bool calendarSync;
  DateTime createdAt;
  DateTime updatedAt;
  int totalTasks;
  int completedTasks;
  int completionRate;
  bool isOverdue;
  int duration;

  ProjectModel({
    required this.id,
    required this.userId,
    required this.areaId,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.startDate,
    required this.endDate,
    required this.hideCompleted,
    required this.energyLevel,
    required this.calendarSync,
    required this.createdAt,
    required this.updatedAt,
    required this.totalTasks,
    required this.completedTasks,
    required this.completionRate,
    required this.isOverdue,
    required this.duration,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json["_id"],
    userId: json["userId"],
    areaId: json["areaId"],
    name: json["name"],
    description: json["description"],
    color: json["color"],
    icon: json["icon"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    hideCompleted: json["hideCompleted"],
    energyLevel: json["energyLevel"],
    calendarSync: json["calendarSync"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    totalTasks: json["totalTasks"],
    completedTasks: json["completedTasks"],
    completionRate: json["completionRate"],
    isOverdue: json["isOverdue"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "areaId": areaId,
    "name": name,
    "description": description,
    "color": color,
    "icon": icon,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "hideCompleted": hideCompleted,
    "energyLevel": energyLevel,
    "calendarSync": calendarSync,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "totalTasks": totalTasks,
    "completedTasks": completedTasks,
    "completionRate": completionRate,
    "isOverdue": isOverdue,
    "duration": duration,
  };
}
