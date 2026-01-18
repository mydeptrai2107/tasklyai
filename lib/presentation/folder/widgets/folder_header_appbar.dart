import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';
import 'package:tasklyai/presentation/folder/widgets/set_folder_password_sheet.dart';

enum _HeaderAction { edit, delete }

class FolderHeaderAppBar extends StatelessWidget {
  final FolderModel folder;
  final AreaModel area;

  final Function(String? pw) onChange;

  const FolderHeaderAppBar({
    super.key,
    required this.folder,
    required this.area,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final hasPassword = folder.passwordHash != null;

    return Row(
      children: [
        const BackButton(color: Colors.white),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            if (!hasPassword) {
              _showSetPasswordSheet(context);
            } else {
              context.read<FolderProvider>().unlockFolder(
                context,
                area.id,
                folder.id,
              );
              onChange.call(null);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Folder unlocked 🔓')),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasPassword ? Icons.lock_outline : Icons.lock_open,
              color: Colors.white,
            ),
          ),
        ),

        PopupMenuButton<_HeaderAction>(
          icon: Icon(Icons.more_vert, color: Colors.white),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case _HeaderAction.edit:
                break;
              case _HeaderAction.delete:
                DialogService.confirm(
                  context,
                  message: 'Bạn có chắc chắn muốn xóa?',
                  onConfirm: () {
                    context.read<FolderProvider>().deleteFolder(
                      context,
                      folder.id,
                      area.id,
                    );
                  },
                );
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _HeaderAction.edit,
              child: _MenuItem(icon: Icons.edit_outlined, text: 'Edit'),
            ),
            PopupMenuItem(
              value: _HeaderAction.delete,
              child: _MenuItem(
                icon: Icons.delete_outline,
                text: 'Delete',
                isDanger: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSetPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SetFolderPasswordSheet(
        folder: folder,
        area: area,
        onChange: onChange,
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDanger;

  const _MenuItem({
    required this.icon,
    required this.text,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : Colors.black87;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
