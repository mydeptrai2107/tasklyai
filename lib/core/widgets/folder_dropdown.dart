import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';

class FolderDropdown extends StatefulWidget {
  final ValueChanged<FolderModel> onChanged;
  final FolderModel? initValue;

  const FolderDropdown({super.key, required this.onChanged, this.initValue});

  @override
  State<FolderDropdown> createState() => _FolderDropdownState();
}

class _FolderDropdownState extends State<FolderDropdown> {
  FolderModel? folderSelected;

  @override
  void initState() {
    folderSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final folder = context.watch<FolderProvider>().folders;

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
            Spacer(),
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
          itemCount: workspaces.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final ws = workspaces[index];
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
