import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/card_model.dart';

class NoteRepository {
  final _dioClient = DioClient();

  Future<List<CardModel>> fetchAllCard() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.notes);
      return (res.data['cards'] as List<dynamic>)
          .map((e) => CardModel.fromJson(e))
          .toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

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

  Future<CardModel> fetchNoteById(String noteId) async {
    try {
      final res = await _dioClient.get('${ApiEndpoint.notes}/$noteId');
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<String?> createNote(Map<String, dynamic> req) async {
    try {
      final res = await _dioClient.post(ApiEndpoint.notes, data: req);
      return _extractCardId(res.data);
    } on FormatException catch (e) {
      rethrow;
    }
  }

  Future<CardModel> addBlockWithFile({
    required String cardId,
    required File file,
    String type = 'image',
    String? caption,
    bool isPinned = false,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'type': type,
        if (caption != null) 'caption': caption,
        'isPinned': isPinned.toString(),
      });
      final res = await _dioClient.post(
        '${ApiEndpoint.notes}/$cardId/blocks/with-file',
        data: formData,
      );
      final data = res.data;
      if (data is Map<String, dynamic> && data['card'] is Map<String, dynamic>) {
        return CardModel.fromJson(data['card']);
      }
      return CardModel.fromJson(data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> updateNote(String noteId, Map<String, dynamic> req) async {
    try {
      await _dioClient.put('${ApiEndpoint.notes}/$noteId', data: req);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _dioClient.delete('${ApiEndpoint.notes}/$noteId');
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> addBlock(String cardId, Map<String, dynamic> data) async {
    try {
      final res = await _dioClient.post(
        '${ApiEndpoint.notes}/$cardId/blocks',
        data: data,
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> updateBlock(
    String cardId,
    String blockId,
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _dioClient.put(
        '${ApiEndpoint.notes}/$cardId/blocks/$blockId',
        data: data,
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> deleteBlock(String cardId, String blockId) async {
    try {
      final res = await _dioClient.delete(
        '${ApiEndpoint.notes}/$cardId/blocks/$blockId',
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> reorderBlocks(
    String cardId,
    List<Map<String, dynamic>> blockOrders,
  ) async {
    try {
      final res = await _dioClient.put(
        '${ApiEndpoint.notes}/$cardId/blocks/reorder',
        data: {'blockOrders': blockOrders},
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> updateAllBlocks(
    String cardId,
    List<Map<String, dynamic>> blocks,
  ) async {
    try {
      final res = await _dioClient.put(
        '${ApiEndpoint.notes}/$cardId/blocks',
        data: {'blocks': blocks},
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> togglePinBlock(String cardId, String blockId) async {
    try {
      final res = await _dioClient.patch(
        '${ApiEndpoint.notes}/$cardId/blocks/$blockId/toggle-pin',
        data: {},
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<CardModel> convertToTask(
    String cardId,
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _dioClient.post(
        '${ApiEndpoint.notes}/$cardId/convert-to-task',
        data: data,
      );
      return CardModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  String? _extractCardId(dynamic data) {
    if (data is Map<String, dynamic>) {
      final directId = data['_id'];
      if (directId is String) return directId;

      final card = data['card'];
      if (card is Map<String, dynamic> && card['_id'] is String) {
        return card['_id'] as String;
      }

      final payload = data['data'];
      if (payload is Map<String, dynamic> && payload['_id'] is String) {
        return payload['_id'] as String;
      }
    }
    return null;
  }
}
