import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final bool isPassword;
  final Widget? suffixIcon; // ✅ THÊM
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.hint,
    this.icon,
    this.isPassword = false,
    this.suffixIcon, // ✅ THÊM
    this.controller,
    this.validator,
    this.maxLines,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      maxLines: widget.isPassword ? 1 : (widget.maxLines ?? 1),
      style: textTheme.bodyMedium,
      validator: widget.validator,
      onChanged: widget.onChanged,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: textTheme.bodySmall?.copyWith(color: Colors.grey.shade500),

        /// PREFIX ICON
        prefixIcon: widget.icon != null
            ? Icon(widget.icon, size: 20, color: Colors.grey)
            : null,

        /// SUFFIX ICON (ƯU TIÊN PASSWORD)
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
              )
            : widget.suffixIcon, // ✅ DÙNG ICON TRUYỀN VÀO

        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
