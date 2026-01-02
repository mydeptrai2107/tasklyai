// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  String id;
  String user;
  String name;
  String description;
  String color;
  String icon;
  String status;
  DateTime startDate;
  DateTime endDate;
  int progress;
  DateTime createdAt;
  TaskStats taskStats;

  ProjectModel({
    required this.id,
    required this.user,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.createdAt,
    required this.taskStats,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json["_id"],
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
    taskStats: TaskStats.fromJson(json["taskStats"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "name": name,
    "description": description,
    "color": color,
    "icon": icon,
    "status": status,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "progress": progress,
    "createdAt": createdAt.toIso8601String(),
    "taskStats": taskStats.toJson(),
  };
}

class TaskStats {
  int total;
  int completed;
  int inProgress;
  int notStarted;

  TaskStats({
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.notStarted,
  });

  factory TaskStats.fromJson(Map<String, dynamic> json) => TaskStats(
    total: json["total"] ?? 0,
    completed: json["completed"] ?? 0,
    inProgress: json["inProgress"] ?? 0,
    notStarted: json["notStarted"] ?? 0,
  );

  double process() {
    if (total == 0) {
      return 0;
    }
    return completed / total;
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "completed": completed,
    "inProgress": inProgress,
    "notStarted": notStarted,
  };
}
