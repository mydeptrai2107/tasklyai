import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/repository/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository noteRepository = NoteRepository();

  List<CardModel> _notes = [];
  List<CardModel> get notes => _notes;

  bool get hasNotes => _notes.isNotEmpty;

  Future<void> fetchNote(String folderId) async {
    try {
      _notes = await noteRepository.fetchNote(folderId);
    } on FormatException catch (_) {
    } finally {
      notifyListeners();
    }
  }

  Future<void> createNote(
    BuildContext context,
    String folderId,
    Map<String, dynamic> req,
  ) async {
    try {
      await noteRepository.createNote(req);
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Tạo note thành công',
          onOk: () {
            Navigator.pop(context);
          },
        );
        fetchNote(folderId);
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }
}
