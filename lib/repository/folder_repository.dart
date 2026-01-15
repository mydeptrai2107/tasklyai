import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/create_folder_req.dart';
import 'package:tasklyai/models/folder_model.dart';

class FolderRepository {
  final _dioClient = DioClient();

  Future<List<FolderModel>> fetchFolder(String areaId) async {
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
}
