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
import 'package:tasklyai/presentation/notes/widgets/voice_to_task_bottom_sheet.dart';
import 'package:tasklyai/presentation/project/provider/ai_provider.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';

class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key, this.areaModel});

  final AreaModel? areaModel;

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  DateTime? startDate;
  DateTime? deadline;

  Color selectedColor = Colors.deepPurple;
  IconData selectedIcon = Icons.work;
  late AreaModel? areaSelected;

  @override
  void initState() {
    areaSelected = widget.areaModel;
    super.initState();
  }

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

  Future<void> pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (startDate != null) {
            startController.text = Formatter.date(startDate!);
          }
          if (deadline != null && deadline!.isBefore(picked)) {
            deadline = null;
          }
        } else {
          deadline = picked;
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
    final bool canSave = nameController.text.trim().isNotEmpty;
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Project', style: textTheme.titleMedium),
        actions: [
          Consumer<AiProvider>(
            builder: (context, value, child) {
              return TextButton(
                onPressed: canSave
                    ? () {
                        context.read<ProjectProvider>().createProject(
                          context,
                          areaSelected!.id,
                          ProjectReq(
                            name: nameController.text,
                            areaId: areaSelected!.id,
                            description: descController.text,
                            icon: selectedIcon.codePoint,
                            color: selectedColor.toARGB32(),
                            startDate: startDate!,
                            endDate: deadline!,
                          ),
                        );
                      }
                    : null,
                child: const Text('Save'),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// AI Assistant
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Project Assistant',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Let AI help you create a structured project plan',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => VoiceToTaskBottomSheet(areaSelected!),
                      );
                    },
                    child: const Text('Use AI'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text('Workspace', style: textTheme.titleSmall),
            const SizedBox(height: 12),
            WorkspaceDropdown(
              initValue: areaSelected,
              onChanged: (value) {
                areaSelected = value;
              },
            ),

            const SizedBox(height: 24),

            /// Project Icon & Color
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

            /// Project Name
            Text('Project Name', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            AppTextField(
              controller: nameController,
              hint: 'Enter project name',
            ),

            const SizedBox(height: 24),

            /// Description
            Text('Description', style: textTheme.titleSmall),
            const SizedBox(height: 8),
            AppTextField(
              controller: descController,
              maxLines: 6,
              hint: 'Describe your project...',
            ),

            const SizedBox(height: 8),

            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.calendar_today, size: 16),
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

                Expanded(
                  child: Column(
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Icon(Icons.calendar_today, size: 16),
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
}
