import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/validator.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/presentation/auth/provider/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Họ và tên'),
          const SizedBox(height: 8),
          AppTextField(
            controller: _nameController,
            hint: 'Nhập họ và tên',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Họ tên không được để trống';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          const Text('Email'),
          const SizedBox(height: 8),
          AppTextField(
            controller: _emailController,
            hint: 'your@email.com',
            icon: Icons.email_outlined,
            validator: Validator.validEmail,
          ),

          const SizedBox(height: 16),

          const Text('Mật khẩu'),
          const SizedBox(height: 8),
          AppTextField(
            controller: _pwController,
            hint: '••••••••',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validator.validPassword,
          ),

          const SizedBox(height: 16),

          const Text('Xác nhận mật khẩu'),
          const SizedBox(height: 8),
          AppTextField(
            controller: _confirmController,
            hint: '••••••••',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: Validator.validPassword,
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthProvider>().register(
                    context,
                    _nameController.text,
                    _emailController.text,
                    _pwController.text,
                    () {
                      _nameController.clear();
                      _emailController.clear();
                      _pwController.clear();
                      _confirmController.clear();
                    },
                  );
                }
              },
              child: const Text('Tạo tài khoản'),
            ),
          ),
        ],
      ),
    );
  }
}
