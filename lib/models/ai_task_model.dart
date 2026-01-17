// To parse this JSON data, do
//
//     final analyzeNoteModel = analyzeNoteModelFromJson(jsonString);

import 'dart:convert';

import 'package:tasklyai/core/enum/priority_enum.dart';

AiTaskModel analyzeNoteModelFromJson(String str) =>
    AiTaskModel.fromJson(json.decode(str));

String analyzeNoteModelToJson(AiTaskModel data) => json.encode(data.toJson());

class AiTaskModel {
  String taskId;
  String taskText;
  int estimatedTimeMinutes;
  Priority priority;
  String suggestedProject;
  String suggestedTopic;
  DateTime createdAt;
  bool isSlected;

  AiTaskModel({
    required this.taskId,
    required this.taskText,
    required this.estimatedTimeMinutes,
    required this.priority,
    required this.suggestedProject,
    required this.suggestedTopic,
    required this.createdAt,
    this.isSlected = true,
  });

  factory AiTaskModel.fromJson(Map<String, dynamic> json) => AiTaskModel(
    taskId: json["task_id"],
    taskText: json["task_text"],
    estimatedTimeMinutes: json["estimated_time_minutes"],
    priority: Priority.fromString(json["priority"]),
    suggestedProject: json["suggested_project"],
    suggestedTopic: json["suggested_topic"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "task_text": taskText,
    "estimated_time_minutes": estimatedTimeMinutes,
    "priority": priority.label,
    "suggested_topic": suggestedTopic,
  };
}
