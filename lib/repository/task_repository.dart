import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/fetch_task_params.dart';
import 'package:tasklyai/data/requests/task_req.dart';
import 'package:tasklyai/models/task_model.dart';

class TaskRepository {
  final _dioClient = DioClient();

  Future<void> createTask(TaskReq task) async {
    try {
      await _dioClient.post(ApiEndpoint.tasks, data: task.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<List<TaskModel>> fetchTask({FetchTaskParams? params}) async {
    try {
      final res = await _dioClient.get(
        ApiEndpoint.tasks,
        params: params?.toJson(),
      );
      final data = res.data['data'] as List<dynamic>?;
      if (data == null) {
        throw FormatException('Không có dữ liệu');
      }
      return data.map((e) => TaskModel.fromJson(e)).toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> updateTask(Map<String, dynamic> params, String taskId) async {
    try {
      await _dioClient.put('${ApiEndpoint.tasks}/$taskId', data: params);
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
