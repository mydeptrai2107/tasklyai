import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/main_screen.dart';
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
}
