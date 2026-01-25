import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/ai_folder_suggestion.dart';
import 'package:tasklyai/models/quick_note_model.dart';
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

  Future<QuickNoteModel> quickNoteAI(String text) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoint.aiQuickNote,
        data: {'text': text},
      );
      if (res.data['note'] == null) {
        throw FormatException('AI không thành công');
      }
      return QuickNoteModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<AiFolderSuggestion> suggestFolder(String text) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoint.aiSuggestFolder,
        data: {'text': text},
      );
      return AiFolderSuggestion.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
