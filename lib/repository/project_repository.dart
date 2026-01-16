import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/project_model.dart';

class ProjectRepository {
  final _dioClient = DioClient();

  Future<void> createProject(ProjectReq project) async {
    try {
      await _dioClient.post(ApiEndpoint.projects, data: project.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<List<ProjectModel>> fetchProjectByArea(String areaId) async {
    try {
      final res = await _dioClient.get(
        ApiEndpoint.projects,
        params: {"areaId": areaId},
      );
      final data = (res.data["projects"] as List<dynamic>?);
      if (data == null) {
        throw FormatException('Lỗi hệ thống');
      }
      return data.map((e) => ProjectModel.fromJson(e)).toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
