import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';

class SetFolderPasswordSheet extends StatefulWidget {
  final FolderModel folder;

  final Function(String? pw) onChange;

  const SetFolderPasswordSheet({
    super.key,
    required this.folder,
    required this.onChange,
  });

  @override
  State<SetFolderPasswordSheet> createState() => _SetFolderPasswordSheetState();
}

class _SetFolderPasswordSheetState extends State<SetFolderPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _header(),
              const SizedBox(height: 20),
              _passwordField(),
              const SizedBox(height: 14),
              _confirmField(),
              const SizedBox(height: 24),
              _saveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        Icon(Icons.lock_outline, size: 36, color: Colors.deepPurple),
        SizedBox(height: 8),
        Text(
          'Set Folder Password',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        Text(
          'Protect your folder with a password',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscure,
      decoration: _inputDecoration('Password'),
      validator: (v) {
        if (v == null || v.length < 4) {
          return 'Password must be at least 4 characters';
        }
        return null;
      },
    );
  }

  Widget _confirmField() {
    return TextFormField(
      controller: _confirmController,
      obscureText: _obscure,
      decoration: _inputDecoration('Confirm Password'),
      validator: (v) {
        if (v != _passwordController.text) {
          return 'Password does not match';
        }
        return null;
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;
          try {
            final password = _passwordController.text.trim();
            context.read<FolderProvider>().protectFolder(
              widget.folder.areaId,
              widget.folder.id,
              password,
            );
            widget.onChange.call(password);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tạo mật khẩu cho Folder thành công'),
              ),
            );
          } catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo mật khẩu cho Folder thất bại')),
            );
          }
        },
        child: const Text(
          'Save Password',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
