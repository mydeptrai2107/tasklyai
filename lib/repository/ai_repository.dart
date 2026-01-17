import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/ai_project_model.dart';
import 'package:tasklyai/models/ai_task_model.dart';

class AiRepository {
  final _dioClient = DioClient();

  Future<AiProjectModel?> analyzeNote(String text) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoint.analyzeNote,
        data: {'content': text, "attachments": []},
      );
      final data = res.data['analysis'];
      final aiTasks = data['aiTasks'] as List<dynamic>?;
      if (data == null || aiTasks == null || aiTasks.isEmpty) {
        return null;
      }
      final tasks = aiTasks.map((e) => AiTaskModel.fromJson(e)).toList();
      return AiProjectModel(
        aiTasks: tasks,
        content: text,
        name: data['suggestedProject'] ?? '',
      );
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createTaskFromAi(
    List<AiTaskModel> tasks,
    ProjectReq projectReq,
  ) async {
    try {
      await _dioClient.post(
        ApiEndpoint.aiCreateTasks,
        data: {
          "autoCreateCategories": true,
          "projectInfo": projectReq.toJson(),
          "tasks": tasks.map((e) => e.toJson()).toList(),
        },
      );
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
