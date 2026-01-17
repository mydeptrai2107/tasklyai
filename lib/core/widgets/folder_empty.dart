import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/folder/create_folder_screen.dart';

class FolderEmpty extends StatelessWidget {
  const FolderEmpty(this.areaModel, {super.key});

  final AreaModel areaModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.folder_open, size: 36, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          const Text(
            'No folders yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first folder to organize projects and notes',
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CreateFolderScreen(areaModel: areaModel),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Folder'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
