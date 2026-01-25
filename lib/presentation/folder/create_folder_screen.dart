import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/data/requests/create_folder_req.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';

class CreateFolderScreen extends StatefulWidget {
  const CreateFolderScreen({super.key, required this.areaModel});

  final AreaModel areaModel;

  @override
  State<CreateFolderScreen> createState() => _CreateFolderScreenState();
}

class _CreateFolderScreenState extends State<CreateFolderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  IconData selectedIcon = Icons.work;
  Color selectedColor = const Color(0xFF7AA2FF);

  final List<IconData> icons = [
    Icons.work,
    Icons.lightbulb,
    Icons.folder,
    Icons.flag,
    Icons.home,
    Icons.star,
    Icons.palette,
    Icons.school,
    Icons.shopping_bag,
    Icons.music_note,
    Icons.build,
    Icons.search,
  ];

  final List<Color> colors = [
    const Color(0xFF7AA2FF),
    const Color(0xFFA5D6A7),
    const Color(0xFFFFD54F),
    const Color(0xFFFFAB91),
    const Color(0xFFD1A3FF),
    const Color(0xFF90CAF9),
    const Color(0xFF80CBC4),
    const Color(0xFFFFCCBC),
    const Color(0xFFB39DDB),
    const Color(0xFF81C784),
    const Color(0xFFFFB74D),
    const Color(0xFFF06292),
  ];

  bool get isValid => nameController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(
          'Create Folder',
          style: context.theme.textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _inputCard(
              title: 'Folder Name *',
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter folder name...',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            _inputCard(
              title: 'Description (optional)',
              child: TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add a description...',
                  border: InputBorder.none,
                ),
              ),
            ),
            _inputCard(
              title: 'Choose icon',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: icons.map((icon) {
                  final isSelected = icon == selectedIcon;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedIcon = icon);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? selectedColor.withAlpha(40)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? selectedColor
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Icon(icon, color: selectedColor),
                    ),
                  );
                }).toList(),
              ),
            ),
            _inputCard(
              title: 'Choose Color',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colors.map((color) {
                  final isSelected = color == selectedColor;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedColor = color);
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                        _createFolder(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isValid
                      ? selectedColor
                      : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Create Folder',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  void _createFolder(BuildContext context) {
    final folder = CreateFolderReq(
      name: nameController.text,
      description: descController.text,
      icon: selectedIcon.codePoint,
      color: selectedColor.toARGB32(),
      areaId: widget.areaModel.id,
    );

    context.read<FolderProvider>().createFolder(context, folder);
  }
}
