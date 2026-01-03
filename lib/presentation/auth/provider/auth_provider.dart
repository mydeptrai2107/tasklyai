import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/main_screen.dart';
import 'package:tasklyai/presentation/profile/provider/profile_provider.dart';
import 'package:tasklyai/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository = AuthRepository();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await repository.login(email, password);

      if (context.mounted) {
        context.read<ProfileProvider>().findMe();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: 'Đăng nhập thất bại');
      }
    }
  }

  Future<void> register(
    BuildContext context,
    String name,
    String email,
    String password,
    VoidCallback? voiCallBack,
  ) async {
    try {
      await repository.register(name, email, password);

      if (context.mounted) {
        DialogService.success(
          context,
          message: 'Đăng ký thành công',
          onOk: () {
            voiCallBack?.call();
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        DialogService.error(context, message: 'Đăng ký thất bại');
      }
    }
  }
}
