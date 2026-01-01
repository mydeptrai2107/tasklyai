import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/project_model.dart';

class ProjectRepository {
  final _dioClient = DioClient();
  Future<void> createProject(ProjectModel projectModel) async {
    try {
      await _dioClient.post(ApiEndpoint.projects, data: projectModel.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
