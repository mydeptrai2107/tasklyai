// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/core/enum/task_status.dart';

TaskModel taskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String taskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  String id;
  String user;
  String title;
  String description;
  Project project;
  dynamic category;
  Priority priority;
  TaskStatus status;
  dynamic startDate;
  DateTime dueDate;
  dynamic completedAt;
  dynamic estimatedMinutes;
  dynamic reminderDate;
  bool reminderSent;
  List<dynamic> tags;
  List<Subtask> subtasks;
  dynamic createdFromNote;
  bool aiGenerated;
  DateTime createdAt;

  TaskModel({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.project,
    required this.category,
    required this.priority,
    required this.status,
    required this.startDate,
    required this.dueDate,
    required this.completedAt,
    required this.estimatedMinutes,
    required this.reminderDate,
    required this.reminderSent,
    required this.tags,
    required this.subtasks,
    required this.createdFromNote,
    required this.aiGenerated,
    required this.createdAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["_id"],
    user: json["user"],
    title: json["title"],
    description: json["description"],
    project: Project.fromJson(json["project"]),
    category: json["category"],
    priority: Priority.fromString(json["priority"]),
    status: TaskStatus.fromString(json["status"]),
    startDate: json["startDate"],
    dueDate: DateTime.parse(json["dueDate"] ?? DateTime.now().toString()),
    completedAt: json["completedAt"],
    estimatedMinutes: json["estimatedMinutes"],
    reminderDate: json["reminderDate"],
    reminderSent: json["reminderSent"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    subtasks: List<Subtask>.from(
      json["subtasks"].map((x) => Subtask.fromJson(x)),
    ),
    createdFromNote: json["createdFromNote"],
    aiGenerated: json["aiGenerated"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user,
    "title": title,
    "description": description,
    "project": project.toJson(),
    "category": category,
    "priority": priority,
    "status": status,
    "startDate": startDate,
    "dueDate": dueDate.toIso8601String(),
    "completedAt": completedAt,
    "estimatedMinutes": estimatedMinutes,
    "reminderDate": reminderDate,
    "reminderSent": reminderSent,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "subtasks": List<dynamic>.from(subtasks.map((x) => x.toJson())),
    "createdFromNote": createdFromNote,
    "aiGenerated": aiGenerated,
    "createdAt": createdAt.toIso8601String(),
  };
}

class Project {
  String id;
  String name;
  String color;

  Project({required this.id, required this.name, required this.color});

  factory Project.fromJson(Map<String, dynamic> json) =>
      Project(id: json["_id"], name: json["name"], color: json["color"]);

  Map<String, dynamic> toJson() => {"_id": id, "name": name, "color": color};
}

class Subtask {
  String title;
  bool isCompleted;
  String? id;

  Subtask({required this.title, required this.isCompleted, this.id});

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
    title: json["title"],
    isCompleted: json["isCompleted"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {"title": title, "isCompleted": isCompleted};
}
