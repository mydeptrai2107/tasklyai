import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/validator.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/presentation/auth/provider/auth_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController(text: 'test@example.com');
  final _pwController = TextEditingController(text: 'password123');

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Quên mật khẩu?'),
            ),
          ),

          const SizedBox(height: 8),

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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  context.read<AuthProvider>().login(
                    context,
                    _emailController.text,
                    _pwController.text,
                  );
                }
              },
              child: const Text('Đăng nhập →'),
            ),
          ),
        ],
      ),
    );
  }
}
