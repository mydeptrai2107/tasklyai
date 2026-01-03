// To parse this JSON data, do
//
//     final analyzeNoteModel = analyzeNoteModelFromJson(jsonString);

import 'dart:convert';

import 'package:tasklyai/core/enum/priority_enum.dart';

AnalyzeNoteModel analyzeNoteModelFromJson(String str) =>
    AnalyzeNoteModel.fromJson(json.decode(str));

String analyzeNoteModelToJson(AnalyzeNoteModel data) =>
    json.encode(data.toJson());

class AnalyzeNoteModel {
  String taskId;
  String taskText;
  int estimatedTimeMinutes;
  Priority priority;
  String suggestedProject;
  String suggestedTopic;
  DateTime createdAt;
  bool isSlected;

  AnalyzeNoteModel({
    required this.taskId,
    required this.taskText,
    required this.estimatedTimeMinutes,
    required this.priority,
    required this.suggestedProject,
    required this.suggestedTopic,
    required this.createdAt,
    this.isSlected = true,
  });

  factory AnalyzeNoteModel.fromJson(Map<String, dynamic> json) =>
      AnalyzeNoteModel(
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
