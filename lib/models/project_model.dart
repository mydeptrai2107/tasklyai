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
  String? permission;
  DateTime? sharedAt;

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
    this.permission,
    this.sharedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json["_id"],
    userId: json["userId"] is Map<String, dynamic>
        ? (json["userId"]["_id"] ?? '')
        : (json["userId"] ?? ''),
    areaId: json["areaId"] is Map<String, dynamic>
        ? (json["areaId"]["_id"] ?? '')
        : (json["areaId"] ?? ''),
    name: json["name"],
    description: json["description"],
    color: json["color"],
    icon: json["icon"],
    startDate: json["startDate"] == null
        ? DateTime.now()
        : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null
        ? DateTime.now()
        : DateTime.parse(json["endDate"]),
    hideCompleted: json["hideCompleted"],
    energyLevel: json["energyLevel"],
    calendarSync: json["calendarSync"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    totalTasks: json["totalTasks"] ?? 0,
    completedTasks: json["completedTasks"] ?? 0,
    completionRate: json["completionRate"] ?? 0,
    isOverdue: json["isOverdue"] ?? false,
    duration: json["duration"] ?? 0,
    permission: json["permission"],
    sharedAt: json["sharedAt"] != null
        ? DateTime.tryParse(json["sharedAt"])
        : null,
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
    "permission": permission,
    "sharedAt": sharedAt?.toIso8601String(),
  };
}
