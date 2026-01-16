import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/data/requests/create_area_req.dart';
import 'package:tasklyai/models/area_model.dart';

class AreaRepository {
  final _dioClient = DioClient();

  Future<List<AreaModel>> fetchArea() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.area);
      return (res.data['data'] as List<dynamic>)
          .map((e) => AreaModel.fromJson(e))
          .toList();
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> createArea(CreateAreaReq req) async {
    try {
      await _dioClient.post(ApiEndpoint.area, data: req.toJson());
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
