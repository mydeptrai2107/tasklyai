import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/repository/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository noteRepository = NoteRepository();

  List<CardModel> _notes = [];
  List<CardModel> get notes => _notes;

  List<CardModel> _allCard = [];
  List<CardModel> get allCard => _allCard;

  bool get hasNotes => _notes.isNotEmpty;

  Future<void> fetchAllCard() async {
    try {
      _allCard = await noteRepository.fetchAllCard();
    } on FormatException catch (_) {
    } finally {
      notifyListeners();
    }
  }

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

  Future<void> updateNote({
    required BuildContext context,
    required String folderId,
    required String noteId,
    required Map<String, dynamic> req,
  }) async {
    try {
      await noteRepository.updateNote(noteId, req);
      if (context.mounted) {
        DialogService.success(context, message: 'Update note thành công');
        fetchNote(folderId);
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }
}
