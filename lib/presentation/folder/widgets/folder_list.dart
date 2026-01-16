import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';
import 'package:tasklyai/presentation/folder/widgets/folder_card.dart';

class FolderList extends StatelessWidget {
  const FolderList(this.areaModel, {super.key});

  final AreaModel areaModel;

  @override
  Widget build(BuildContext context) {
    return Selector<FolderProvider, List<FolderModel>>(
      builder: (context, value, child) {
        if (value.isEmpty) {
          return _EmptyFolderState();
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: value.length,
          itemBuilder: (context, index) {
            return FolderCard(item: value[index], areaModel: areaModel);
          },
        );
      },
      selector: (context, p) => p.folders,
    );
  }
}

class _EmptyFolderState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
        _CreateFolderButton(),
      ],
    );
  }
}

class _CreateFolderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // context.read<FolderProvider>().createFolder();
      },
      icon: const Icon(Icons.add),
      label: const Text('Create Folder'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
