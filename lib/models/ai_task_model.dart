import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/core/enum/task_status.dart';

class AiTaskModel {
  String taskText;
  int estimatedTimeMinutes;
  String priority;
  TaskStatus status;
  Priority energyLevel;
  String suggestedTopic;
  int order;
  bool isSelected;

  AiTaskModel({
    required this.taskText,
    required this.estimatedTimeMinutes,
    required this.priority,
    required this.status,
    required this.energyLevel,
    required this.suggestedTopic,
    required this.order,
    this.isSelected = true,
  });

  factory AiTaskModel.fromJson(Map<String, dynamic> json) => AiTaskModel(
    taskText: json["taskText"],
    estimatedTimeMinutes: json["estimatedTimeMinutes"],
    priority: json["priority"],
    status: TaskStatus.fromString(json["status"]),
    energyLevel: Priority.fromString(json["energyLevel"]),
    suggestedTopic: json["suggestedTopic"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "taskText": taskText,
    "estimatedTimeMinutes": estimatedTimeMinutes,
    "priority": priority,
    "status": status.eng,
    "energyLevel": energyLevel.eng.toLowerCase(),
    "suggestedTopic": suggestedTopic,
    "order": order,
  };
}
