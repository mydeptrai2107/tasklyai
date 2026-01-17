import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/presentation/profile/provider/profile_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideOld = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ProfileProvider>().changePassword(
      context,
      _oldPasswordController.text.trim(),
      _newPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update your password',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a strong password to protect your account',
                style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              /// CURRENT PASSWORD
              AppTextField(
                controller: _oldPasswordController,
                hint: 'Current password',
                isPassword: _hideOld,
                suffixIcon: _buildEyeIcon(
                  _hideOld,
                  () => setState(() => _hideOld = !_hideOld),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// NEW PASSWORD
              AppTextField(
                controller: _newPasswordController,
                hint: 'New password',
                isPassword: _hideNew,
                suffixIcon: _buildEyeIcon(
                  _hideNew,
                  () => setState(() => _hideNew = !_hideNew),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu tối thiểu 6 ký tự';
                  }
                  if (value == _oldPasswordController.text) {
                    return 'Mật khẩu mới phải khác mật khẩu cũ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// CONFIRM PASSWORD
              AppTextField(
                controller: _confirmPasswordController,
                hint: 'Confirm new password',
                isPassword: _hideConfirm,
                suffixIcon: _buildEyeIcon(
                  _hideConfirm,
                  () => setState(() => _hideConfirm = !_hideConfirm),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
                  }
                  return null;
                },
              ),

              const Spacer(),

              /// SUBMIT
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    'Update Password',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEyeIcon(bool isHidden, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20,
        color: Colors.grey,
      ),
    );
  }
}
