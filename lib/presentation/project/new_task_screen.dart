import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/core/widgets/project_dropdown.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/provider/task_provider.dart';
import 'package:tasklyai/presentation/project/widgets/add_subtask.dart';
import 'package:tasklyai/presentation/project/widgets/priority_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key, this.projectModel, this.initialDeadline});

  final ProjectModel? projectModel;
  final DateTime? initialDeadline;

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _deadlineController = TextEditingController();

  late ProjectModel? projectSelected;
  Priority prioritySelected = Priority.low;
  List<String> subTask = [];

  @override
  void initState() {
    projectSelected = widget.projectModel;
    if (widget.initialDeadline != null) {
      deadline = widget.initialDeadline;
      _deadlineController.text = formatDate(deadline);
    }
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _deadlineController.dispose();
    _titleController.dispose();
    _descController.dispose();

    super.dispose();
  }

  bool get isDisable =>
      _titleController.text.trim().isEmpty ||
      _descController.text.trim().isEmpty ||
      projectSelected == null;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Task', style: textTheme.titleMedium),
        centerTitle: true,
        actions: [_buildSave(context)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // task title
            Text('Task Title', style: textTheme.bodyMedium),
            SizedBox(height: 6),
            AppTextField(
              controller: _titleController,
              hint: 'Enter task title...',
            ),
            SizedBox(height: 16),

            // description
            Text('Description', style: textTheme.bodyMedium),
            SizedBox(height: 6),
            AppTextField(
              controller: _descController,
              hint: 'Add details about this task...',
              maxLines: 4,
            ),
            SizedBox(height: 16),

            // project
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.folder_outlined, size: 16),
                Text('Project', style: textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 8),
            ProjectDropdown(
              initValue: projectSelected,
              onChanged: (value) {
                projectSelected = value;
                setState(() {});
              },
            ),

            SizedBox(height: 16),

            // Priority
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.flag_outlined, size: 16),
                Text('Priority', style: textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 6),
            PriorityWidget(
              selected: prioritySelected,
              ontap: (priority) {
                prioritySelected = priority;
                setState(() {});
              },
            ),
            SizedBox(height: 16),

            // Deadline
            Row(
              spacing: 8,
              children: [
                Icon(Icons.calendar_today, size: 16),
                Text('Deadline', style: textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => pickDate(isStart: false),
              child: AbsorbPointer(
                child: AppTextField(
                  controller: _deadlineController,
                  hint: 'mm/dd/yyyy',
                ),
              ),
            ),
            SizedBox(height: 16),

            // sub task
            AddSubtask(
              onChange: (value) {
                subTask = value;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  DateTime? deadline;

  Color selectedColor = Colors.deepPurple;

  Future<void> pickDate({required bool isStart}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deadline ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        deadline = picked;
        _deadlineController.text = formatDate(deadline);
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'mm/dd/yyyy';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Widget _buildSave(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return GestureDetector(
      onTap: isDisable
          ? null
          : () {
              final Map<String, dynamic> data = {
                'areaId': projectSelected!.areaId,
                'projectId': projectSelected!.id,
                'title': _titleController.text.trim(),
                'content': _descController.text.trim(),
                'tags': <String>[],
                'energyLevel': prioritySelected.eng.toLowerCase(),
                'status': 'todo',
                'dueDate': deadline?.toIso8601String(),
                'checklist': subTask
                    .map((e) => {'text': e, 'checked': false})
                    .toList(),
              };

              debugPrint(data.toString());

              context.read<TaskProvider>().createTask(
                context,
                projectSelected!.id,
                data,
              );
            },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isDisable ? Colors.grey : primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Save',
          style: textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
