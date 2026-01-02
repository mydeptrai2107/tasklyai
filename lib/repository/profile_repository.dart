import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/profile_model.dart';

class ProfileRepository {
  final _dioClient = DioClient();

  Future<ProfileModel> findMe() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.findMe);
      return ProfileModel.fromJson(res.data['data']);
    } on FormatException catch (_) {
      rethrow;
    }
  }
}
