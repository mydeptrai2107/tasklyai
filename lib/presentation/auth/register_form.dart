import 'package:flutter/material.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Họ và tên'),
          const SizedBox(height: 8),
          const AppTextField(
            hint: 'Nhập họ và tên',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          const Text('Email'),
          const SizedBox(height: 8),
          const AppTextField(
            hint: 'your@email.com',
            icon: Icons.email_outlined,
          ),

          const SizedBox(height: 16),

          const Text('Mật khẩu'),
          const SizedBox(height: 8),
          const AppTextField(
            hint: '••••••••',
            icon: Icons.lock_outline,
            isPassword: true,
          ),

          const SizedBox(height: 16),

          const Text('Xác nhận mật khẩu'),
          const SizedBox(height: 8),
          const AppTextField(
            hint: '••••••••',
            icon: Icons.lock_outline,
            isPassword: true,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text('Tạo tài khoản →'),
            ),
          ),
        ],
      ),
    );
  }
}
