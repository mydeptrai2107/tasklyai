import 'dart:io';

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

  List<CardModel> _archivedCards = [];
  List<CardModel> get archivedCards => _archivedCards;

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

  Future<void> fetchArchivedCards() async {
    try {
      _archivedCards = await noteRepository.fetchArchivedCards();
    } on FormatException catch (_) {
    } finally {
      notifyListeners();
    }
  }

  Future<CardModel?> fetchNoteById(BuildContext context, String noteId) async {
    try {
      return await noteRepository.fetchNoteById(noteId);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<String?> createNote(
    BuildContext context,
    Map<String, dynamic> req,
  ) async {
    try {
      final cardId = await noteRepository.createNote(req);
      if (cardId == null) {
        throw const FormatException('Khong tao duoc card');
      }
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Tao card thanh cong',
          onOk: () {
            return;
          },
        );
      }
      return cardId;
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> addBlockWithFile({
    required BuildContext context,
    required String cardId,
    required File file,
    String type = 'image',
    String? caption,
    bool isPinned = false,
  }) async {
    try {
      return await noteRepository.addBlockWithFile(
        cardId: cardId,
        file: file,
        type: type,
        caption: caption,
        isPinned: isPinned,
      );
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<void> updateNote({
    required BuildContext context,
    required String folderId,
    required String noteId,
    required Map<String, dynamic> req,
    bool isShowDialog = true,
  }) async {
    try {
      await noteRepository.updateNote(noteId, req);
      if (context.mounted) {
        if (isShowDialog) {
          DialogService.success(context, message: 'Update note thanh cong');
        }
        fetchNote(folderId);
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<void> deleteNote(
    BuildContext context,
    String folderId,
    String noteId,
  ) async {
    try {
      await noteRepository.deleteNote(noteId);
      if (context.mounted) {
        fetchNote(folderId);
        Navigator.pop(context);
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
    }
  }

  Future<CardModel?> archiveCard({
    required BuildContext context,
    required CardModel card,
  }) async {
    try {
      final updated = await noteRepository.archiveCard(
        card.id,
        checklist: card.checklist
            .map((e) => {'text': e.text, 'checked': e.checked})
            .toList(),
      );
      if (card.folder?.id != null) {
        fetchNote(card.folder!.id);
      }
      fetchArchivedCards();
      return updated;
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> unarchiveCard({
    required BuildContext context,
    required CardModel card,
  }) async {
    try {
      final updated = await noteRepository.unarchiveCard(
        card.id,
        checklist: card.checklist
            .map((e) => {'text': e.text, 'checked': e.checked})
            .toList(),
      );
      if (card.folder?.id != null) {
        fetchNote(card.folder!.id);
      }
      fetchArchivedCards();
      return updated;
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> addBlock({
    required BuildContext context,
    required String cardId,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await noteRepository.addBlock(cardId, data);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> updateBlock({
    required BuildContext context,
    required String cardId,
    required String blockId,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await noteRepository.updateBlock(cardId, blockId, data);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> deleteBlock({
    required BuildContext context,
    required String cardId,
    required String blockId,
  }) async {
    try {
      return await noteRepository.deleteBlock(cardId, blockId);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> reorderBlocks({
    required BuildContext context,
    required String cardId,
    required List<Map<String, dynamic>> blockOrders,
  }) async {
    try {
      return await noteRepository.reorderBlocks(cardId, blockOrders);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> updateAllBlocks({
    required BuildContext context,
    required String cardId,
    required List<Map<String, dynamic>> blocks,
  }) async {
    try {
      return await noteRepository.updateAllBlocks(cardId, blocks);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> togglePinBlock({
    required BuildContext context,
    required String cardId,
    required String blockId,
  }) async {
    try {
      return await noteRepository.togglePinBlock(cardId, blockId);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }

  Future<CardModel?> convertToTask({
    required BuildContext context,
    required String cardId,
    required DateTime dueDate,
    String? projectId,
    String status = 'todo',
    bool dateOnly = false,
  }) async {
    try {
      final dueDateValue = dateOnly
          ? '${dueDate.year.toString().padLeft(4, '0')}-'
                '${dueDate.month.toString().padLeft(2, '0')}-'
                '${dueDate.day.toString().padLeft(2, '0')}'
          : dueDate.toIso8601String();
      final payload = {
        'dueDate': dueDateValue,
        'status': status,
        if (projectId != null) 'projectId': projectId,
      };
      return await noteRepository.convertToTask(cardId, payload);
    } on FormatException catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: e.message);
      }
      return null;
    }
  }
}
