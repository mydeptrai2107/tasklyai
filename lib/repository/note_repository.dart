import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/card_model.dart';

class NoteRepository {
  final _dioClient = DioClient();

  Future<List<CardModel>> fetchNote(String folderId) async {
    try {
      final res = await _dioClient.get(
        '${ApiEndpoint.folders}/$folderId/cards',
      );
      return (res.data['cards'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e))
          .toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createNote(Map<String, dynamic> req) async {
    try {
      await _dioClient.post(ApiEndpoint.notes, data: req);
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
