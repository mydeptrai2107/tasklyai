import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/create_folder_screen.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';

class FolderDropdown extends StatefulWidget {
  final ValueChanged<FolderModel> onChanged;
  final FolderModel? initValue;
  final String? initFolderId;

  const FolderDropdown({
    super.key,
    required this.onChanged,
    this.initValue,
    this.initFolderId,
  });

  @override
  State<FolderDropdown> createState() => _FolderDropdownState();
}

class _FolderDropdownState extends State<FolderDropdown> {
  FolderModel? folderSelected;
  bool _didInit = false;

  @override
  void initState() {
    folderSelected = widget.initValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FolderDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initValue != null &&
        widget.initValue?.id != oldWidget.initValue?.id) {
      folderSelected = widget.initValue;
      setState(() {});
      return;
    }
    if (widget.initFolderId != null &&
        widget.initFolderId != oldWidget.initFolderId) {
      final folders = context.read<FolderProvider>().folders;
      final match = folders.where((f) => f.id == widget.initFolderId).toList();
      if (match.isNotEmpty) {
        folderSelected = match.first;
        setState(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    if (folderSelected == null && widget.initFolderId != null) {
      final folders = context.read<FolderProvider>().folders;
      final match = folders.where((f) => f.id == widget.initFolderId).toList();
      if (match.isNotEmpty) {
        folderSelected = match.first;
      }
    }
    _didInit = true;
  }

  @override
  Widget build(BuildContext context) {
    final folder = context.watch<FolderProvider>().allFolders;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showBottomSheet(context, folder),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (folderSelected != null)
              IconInt(icon: folderSelected!.icon, color: folderSelected!.color),
            const SizedBox(width: 12),
            if (folderSelected != null)
              Expanded(
                child: Text(
                  folderSelected!.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<FolderModel> workspaces) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: workspaces.length + 1,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            if (index == 0) {
              return ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text(
                  'Add new folder',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final created = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateFolderScreen(),
                    ),
                  );
                  if (created == true && context.mounted) {
                    context.read<FolderProvider>().fetchFolder(null);
                  }
                },
              );
            }
            final ws = workspaces[index - 1];
            return ListTile(
              leading: IconInt(icon: ws.icon, color: ws.color),
              title: Text(
                ws.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                ws.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onChanged(ws);
                folderSelected = ws;
                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
