import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/create_folder_req.dart';
import 'package:tasklyai/models/folder_model.dart';

class FolderRepository {
  final _dioClient = DioClient();

  Future<List<FolderModel>> fetchFolder(String? areaId) async {
    try {
      final res = await _dioClient.get(
        ApiEndpoint.folders,
        params: {"areaId": areaId},
      );
      return (res.data as List<dynamic>)
          .map((e) => FolderModel.fromJson(e))
          .toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createFolder(CreateFolderReq req) async {
    try {
      await _dioClient.post(ApiEndpoint.folders, data: req.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> updateFolder(String idFolder, Map<String, dynamic> req) async {
    try {
      await _dioClient.put('${ApiEndpoint.folders}/$idFolder', data: req);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteFolder(String idFolder) async {
    try {
      await _dioClient.delete('${ApiEndpoint.folders}/$idFolder');
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<bool> verifyFolder(String idFolder, String password) async {
    try {
      final res = await _dioClient.post(
        '${ApiEndpoint.folders}/$idFolder/access',
        data: {"password": password},
      );
      final data = res.data['hasAccess'];
      return data ?? false;
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
