import 'dart:convert';

import 'package:tasklyai/models/ai_project_model.dart';
import 'package:tasklyai/models/ai_task_model.dart';

SuggestionsModel suggestionsModelFromJson(String str) =>
    SuggestionsModel.fromJson(json.decode(str));

String suggestionsModelToJson(SuggestionsModel data) =>
    json.encode(data.toJson());

class SuggestionsModel {
  String? areaId;
  AiProjectModel aiProjectModel;
  List<AiTaskModel> aiTasks;

  SuggestionsModel({
    required this.aiProjectModel,
    required this.aiTasks,
    this.areaId,
  });

  factory SuggestionsModel.fromJson(Map<String, dynamic> json) =>
      SuggestionsModel(
        aiProjectModel: AiProjectModel.fromJson(json["project"]),
        aiTasks: List<AiTaskModel>.from(
          json["tasks"].map((x) => AiTaskModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "areaId": areaId,
    "project": aiProjectModel.toJson(),
    "tasks": List<dynamic>.from(
      aiTasks.where((x) => x.isSelected).map((x) => x.toJson()),
    ),
  };
}
