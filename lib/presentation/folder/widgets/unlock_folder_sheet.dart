import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/folder_detail_screen.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';

class UnlockFolderSheet extends StatefulWidget {
  final FolderModel folder;
  final VoidCallback onSuccess;

  const UnlockFolderSheet({
    super.key,
    required this.folder,
    required this.onSuccess,
  });

  @override
  State<UnlockFolderSheet> createState() => _UnlockFolderSheetState();
}

class _UnlockFolderSheetState extends State<UnlockFolderSheet> {
  final _controller = TextEditingController();
  bool _obscure = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(),
            const SizedBox(height: 20),
            _passwordField(),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 24),
            _unlockButton(context),
          ],
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
          'Unlock Folder',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        Text(
          'Enter password to access this folder',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  Widget _unlockButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          _unlock(context);
        },
        child: const Text(
          'Unlock',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Future<void> _unlock(BuildContext context) async {
    final input = _controller.text.trim();
    try {
      final res = await context.read<FolderProvider>().verifyFolder(
        widget.folder.id,
        input,
      );
      if (res) {
        setState(() => _error = 'Incorrect password');
        return;
      }
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FolderDetailScreen(folder: widget.folder),
          ),
        );
      }
    } catch (e) {
      setState(() => _error = 'Incorrect password');
      return;
    }
  }
}
