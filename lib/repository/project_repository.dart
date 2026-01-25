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

  Future<List<ProjectModel>> fetchAllProjects() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.projects);
      final data = (res.data["projects"] as List<dynamic>?);
      if (data == null) {
        throw FormatException('System error');
      }
      return data.map((e) => ProjectModel.fromJson(e)).toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<ProjectModel> updateProject(
    String projectId,
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await _dioClient.put(
        '${ApiEndpoint.projects}/$projectId',
        data: data,
      );
      return ProjectModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _dioClient.delete('${ApiEndpoint.projects}/$projectId');
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> shareProject(
    String projectId,
    String email,
  ) async {
    try {
      final res = await _dioClient.post(
        '${ApiEndpoint.projects}/$projectId/share',
        data: {'email': email},
      );
      return res.data as Map<String, dynamic>;
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> unshareProject(String projectId, String userId) async {
    try {
      await _dioClient.delete(
        '${ApiEndpoint.projects}/$projectId/share/$userId',
      );
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSharedUsers(String projectId) async {
    try {
      final res = await _dioClient.get(
        '${ApiEndpoint.projects}/$projectId/shares',
      );
      return res.data as Map<String, dynamic>;
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<List<ProjectModel>> fetchSharedWithMe({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _dioClient.get(
        '${ApiEndpoint.projects}/shared/with-me',
        params: {'page': page, 'limit': limit},
      );
      final data = (res.data['projects'] as List<dynamic>? ?? []);
      return data.map((e) => ProjectModel.fromJson(e)).toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
