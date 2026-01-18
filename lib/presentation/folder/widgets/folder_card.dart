import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/folder_detail_screen.dart';
import 'package:tasklyai/presentation/folder/widgets/unlock_folder_sheet.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({super.key, required this.item, required this.areaModel});

  final FolderModel item;
  final AreaModel areaModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final hasPassword = item.passwordHash != null;

    return InkWell(
      onTap: () {
        if (hasPassword) {
          _showUnlockFolderSheet(context);
        } else {
          _openFolder(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(item.color).withAlpha(50),
              ),
              child: IconInt(icon: item.icon, size: 25, color: item.color),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: textTheme.titleMedium),
                  Text(
                    item.description,
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      _DotText(
                        text: '${item.projectCount} projects',
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _DotText(
                        text: '${item.noteCount} notes',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFolder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FolderDetailScreen(folder: item, areaModel: areaModel),
      ),
    );
  }

  void _showUnlockFolderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UnlockFolderSheet(
        folder: item,
        areaModel: areaModel,
        onSuccess: () => _openFolder(context),
      ),
    );
  }
}

class _DotText extends StatelessWidget {
  final String text;
  final Color color;

  const _DotText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
