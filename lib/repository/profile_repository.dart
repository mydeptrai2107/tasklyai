import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tasklyai/core/network/api_endpoint.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/profile_model.dart';

class ProfileRepository {
  final _dioClient = DioClient();

  Future<ProfileModel> findMe() async {
    try {
      final res = await _dioClient.get(ApiEndpoint.userProfile);
      return ProfileModel.fromJson(res.data);
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> changePassword(String oldPw, String newPw) async {
    try {
      await _dioClient.put(
        ApiEndpoint.changePw,
        data: {"currentPassword": oldPw, "newPassword": newPw},
      );
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> updateProfile(String name) async {
    try {
      await _dioClient.put(ApiEndpoint.userProfile, data: {"name": name});
    } on FormatException catch (_) {
      rethrow;
    }
  }

  Future<void> updateAvatar(File avatarFile) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          avatarFile.path,
          filename: avatarFile.path.split('/').last,
        ),
      });

      await _dioClient.put(
        ApiEndpoint.userAvatar, // ví dụ: /api/user/avatar
        data: formData,
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Upload avatar failed');
    }
  }
}
