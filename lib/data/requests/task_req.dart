import 'dart:convert';

TaskReq taskReqFromJson(String str) => TaskReq.fromJson(json.decode(str));

String taskReqToJson(TaskReq data) => json.encode(data.toJson());

class TaskReq {
  String title;
  String description;
  String priority;
  DateTime dueDate;
  String project;
  List<String> subtasks;

  TaskReq({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.project,
    this.subtasks = const [],
  });

  factory TaskReq.fromJson(Map<String, dynamic> json) => TaskReq(
    title: json["title"],
    description: json["description"],
    priority: json["priority"],
    dueDate: DateTime.parse(json["dueDate"]),
    project: json["project"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "priority": priority,
    "dueDate": dueDate.toIso8601String(),
    "project": project,
    "subtasks": subtasks.map((e) => {"title": e}).toList(),
  };
}
