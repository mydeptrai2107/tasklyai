import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_detail_provider.dart';

class FolderFilterTabs extends StatelessWidget {
  final FolderModel folder;

  const FolderFilterTabs({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FolderDetailProvider>();

    return Row(
      children: [
        _FilterChip(
          text: 'All (${folder.noteCount + folder.projectCount})',
          selected: provider.filter == FolderFilterType.all,
          onTap: () => provider.setFilter(FolderFilterType.all),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          text: 'Notes (${folder.noteCount})',
          selected: provider.filter == FolderFilterType.notes,
          onTap: () => provider.setFilter(FolderFilterType.notes),
        ),
        const SizedBox(width: 8),
        _FilterChip(
          text: 'Projects (${folder.projectCount})',
          selected: provider.filter == FolderFilterType.projects,
          onTap: () => provider.setFilter(FolderFilterType.projects),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
