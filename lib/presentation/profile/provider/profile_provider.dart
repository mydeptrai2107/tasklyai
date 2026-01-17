import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/profile_model.dart';
import 'package:tasklyai/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _profile;
  ProfileModel? get profile => _profile;

  final ProfileRepository _repository = ProfileRepository();

  Future<void> findMe() async {
    try {
      _profile = await _repository.findMe();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> changePassword(
    BuildContext context,
    String oldPw,
    String newPw,
  ) async {
    try {
      await _repository.changePassword(oldPw, newPw);
      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Đổi mật khẩu thành công',
          onOk: () {
            Navigator.pop(context);
          },
        );
      }
    } catch (_) {
      if (context.mounted) {
        DialogService.error(context, message: 'Đổi mật khẩu thất bại');
      }
    }
  }

  Future<void> updateProfile(BuildContext context, String name) async {
    try {
      await _repository.updateProfile(name);
      if (context.mounted) {
        findMe();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật hồ sơ thành công')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        DialogService.error(context, message: 'Cập nhật hồ sơ thất bại');
      }
    }
  }

  Future<void> updateAvatar(BuildContext context, File name) async {
    try {
      await _repository.updateAvatar(name);
      if (context.mounted) {
        findMe();
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật ảnh đại diện thành công')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        DialogService.error(context, message: 'Cập nhật ảnh đại diện thất bại');
      }
    }
  }
}
