import 'package:flutter/material.dart';
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
}
