import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/ai_task_model.dart';
import 'package:tasklyai/models/suggestion_model.dart';

class AiRepository {
  final _dioClient = DioClient();

  Future<SuggestionsModel?> analyzeNote(String text) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoint.analyzeNote,
        data: {'projectDescription': text},
      );

      return SuggestionsModel.fromJson(res.data['suggestions']);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createTaskFromAi(SuggestionsModel req) async {
    try {
      await _dioClient.post(ApiEndpoint.aiCreateTasks, data: req.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
