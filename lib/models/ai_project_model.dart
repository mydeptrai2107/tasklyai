import 'package:flutter/material.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';

class AiProjectModel {
  String name;
  String description;
  Priority energyLevel;
  int estimatedDurationDays;
  String priority;
  String suggestedArea;

  AiProjectModel({
    required this.name,
    required this.description,
    required this.energyLevel,
    required this.estimatedDurationDays,
    required this.priority,
    required this.suggestedArea,
  });

  factory AiProjectModel.fromJson(Map<String, dynamic> json) => AiProjectModel(
    name: json["name"],
    description: json["description"],
    energyLevel: Priority.fromString(json["energyLevel"]),
    estimatedDurationDays: json["estimatedDurationDays"],
    priority: json["priority"],
    suggestedArea: json["suggestedArea"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "color": Colors.purple.toARGB32(),
    "icon": Icons.auto_awesome.codePoint,
    "energyLevel": energyLevel.eng.toLowerCase(),
    "estimatedDurationDays": estimatedDurationDays,
    "priority": priority,
    "suggestedArea": suggestedArea,
  };
}
