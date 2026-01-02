import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/data/requests/create_note_req.dart';
import 'package:tasklyai/models/note_model.dart';
import 'package:tasklyai/repository/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository noteRepository = NoteRepository();

  List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  Future<void> fetchNote() async {
    try {
      _notes = await noteRepository.fetchNote();
    } on FormatException catch (_) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> createNote(BuildContext context, CreateNoteReq req) async {
    try {
      await noteRepository.createNote(req);
      if (context.mounted) {
        DialogService.success(context, message: 'Tạo note thành công');
        fetchNote();
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }
}
