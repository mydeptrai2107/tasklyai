import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/analyze_note_model.dart';

class AiRepository {
  final _dioClient = DioClient();

  Future<List<AnalyzeNoteModel>> analyzeNote(String text) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoint.analyzeNote,
        data: {'text': text},
      );
      final data = res.data['data']['tasks'] as List<dynamic>?;
      if (data == null) {
        return [];
      }
      return data.map((e) => AnalyzeNoteModel.fromJson(e)).toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createTaskFromAi(
    List<AnalyzeNoteModel> tasks,
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
