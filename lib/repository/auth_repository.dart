import 'package:tasklyai/core/configs/constant.dart';
import 'package:tasklyai/core/configs/local_storage.dart';
import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';

class AuthRepository {
  final _dioClient = DioClient();
  Future<void> login(String email, String password) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoint.login,
        data: {'email': email, 'password': password},
      );
      final token = res.data['data']?['token'];
      if (token != null) {
        await LocalStorage.setString(kToken, token);
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      await _dioClient.post(
        ApiEndpoint.register,
        data: {'name': name, 'email': email, 'password': password},
      );
    } catch (_) {
      rethrow;
    }
  }
}
