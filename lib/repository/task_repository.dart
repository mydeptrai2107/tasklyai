import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/fetch_task_params.dart';
import 'package:tasklyai/models/card_model.dart';

class TaskRepository {
  final _dioClient = DioClient();

  Future<void> createTask(Map<String, dynamic> data) async {
    try {
      await _dioClient.post(ApiEndpoint.tasks, data: data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<List<CardModel>> fetchTask({FetchTaskParams? params}) async {
    try {
      final res = await _dioClient.get(
        ApiEndpoint.tasks,
        params: params?.toJson(),
      );
      final data = res.data['cards'] as List<dynamic>?;
      if (data == null) {
        throw FormatException('Không có dữ liệu');
      }
      return data.map((e) => CardModel.fromJson(e)).toList();
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
