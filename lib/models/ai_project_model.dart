import 'package:tasklyai/models/ai_task_model.dart';

class AiProjectModel {
  List<AiTaskModel> aiTasks;
  String name;
  String content;

  AiProjectModel({
    required this.aiTasks,
    required this.content,
    required this.name,
  });
}
