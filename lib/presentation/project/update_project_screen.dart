import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/core/widgets/choose_icon.dart';
import 'package:tasklyai/core/widgets/workspace_dropdown.dart';
import 'package:tasklyai/data/requests/project_req.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';

class UpdateProjectScreen extends StatefulWidget {
  const UpdateProjectScreen({super.key, required this.project});

  final ProjectModel project;

  @override
  State<UpdateProjectScreen> createState() => _UpdateProjectScreenState();
}

class _UpdateProjectScreenState extends State<UpdateProjectScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  DateTime? startDate;
  DateTime? deadline;

  Color selectedColor = Colors.deepPurple;
  IconData selectedIcon = Icons.work;
  AreaModel? areaSelected;
  bool _didInitArea = false;

  final List<Color> colors = [
    Colors.deepPurple,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.deepOrange,
  ];

  @override
  void initState() {
    final project = widget.project;
    nameController.text = project.name;
    descController.text = project.description;
    startDate = project.startDate;
    deadline = project.endDate;
    startController.text = Formatter.date(project.startDate);
    endController.text = Formatter.date(project.endDate);
    selectedColor = Color(project.color);
    selectedIcon = IconData(project.icon, fontFamily: 'MaterialIcons');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitArea) return;
    final areas = context.read<AreaProvider>().areas;
    final match = areas.where((a) => a.id == widget.project.areaId).toList();
    if (match.isNotEmpty) {
      areaSelected = match.first;
    }
    _didInitArea = true;
  }

  Future<void> pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? startDate ?? DateTime.now()
          : deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          startController.text = Formatter.date(startDate!);
          if (deadline != null && deadline!.isBefore(picked)) {
            deadline = null;
            endController.clear();
          }
        } else {
          deadline = picked;
          endController.text = Formatter.date(deadline!);
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'mm/dd/yyyy';
    return DateFormat('MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool canSave =
        nameController.text.trim().isNotEmpty &&
        startDate != null &&
        deadline != null;
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Project', style: textTheme.titleMedium),
        actions: [
          TextButton(
            onPressed: canSave ? () => _updateProject(context) : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workspace', style: textTheme.titleSmall),
            const SizedBox(height: 12),
            WorkspaceDropdown(
              initValue: areaSelected,
              onChanged: (value) {
                areaSelected = value;
              },
            ),
            const SizedBox(height: 24),
            Text('Project Color', style: textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Wrap(
                  spacing: 8,
                  children: colors.map((color) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: color,
                        child: selectedColor == color
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ChooseIcon(
              selectedColor: selectedColor,
              onChange: (value) {
                selectedIcon = value;
              },
            ),
            Text('Project Name', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            AppTextField(
              controller: nameController,
              hint: 'Enter project name',
            ),
            const SizedBox(height: 24),
            Text('Description', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            AppTextField(
              controller: descController,
              maxLines: 6,
              hint: 'Describe your project...',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Text('Start Date', style: textTheme.titleSmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => pickDate(isStart: true),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: startController,
                            decoration: InputDecoration(
                              hintText: formatDate(startDate),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Text('Deadline', style: textTheme.titleSmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: startDate == null
                            ? null
                            : () => pickDate(isStart: false),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: endController,
                            decoration: InputDecoration(
                              hintText: formatDate(deadline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProject(BuildContext context) async {
    final areaId = areaSelected?.id ?? widget.project.areaId;
    final req = ProjectReq(
      name: nameController.text.trim(),
      areaId: areaId,
      description: descController.text.trim(),
      icon: selectedIcon.codePoint,
      color: selectedColor.toARGB32(),
      startDate: startDate!,
      endDate: deadline!,
    );
    final updated = await context.read<ProjectProvider>().updateProject(
      context,
      areaId,
      widget.project.id,
      req,
    );
    if (!context.mounted) return;
    if (updated != null) {
      Navigator.pop(context, updated);
    }
  }
}
