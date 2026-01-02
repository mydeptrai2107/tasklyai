import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/create_note_req.dart';
import 'package:tasklyai/models/note_model.dart';

class NoteRepository {
  final _dioClient = DioClient();

  Future<List<NoteModel>> fetchNote() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.notes);
      return (res.data['data'] as List<dynamic>)
          .map((e) => NoteModel.fromJson(e))
          .toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createNote(CreateNoteReq req) async {
    try {
      await _dioClient.post(ApiEndpoint.notes, data: req.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
