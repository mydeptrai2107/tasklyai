import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.maxLines,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines ?? 1,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        hintText: hint,
        hintStyle: textTheme.bodySmall?.copyWith(color: Colors.grey),
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: isPassword ? const Icon(Icons.visibility_off) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
