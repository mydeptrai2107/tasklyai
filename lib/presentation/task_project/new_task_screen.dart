import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/data/requests/task_req.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/add_subtask.dart';
import 'package:tasklyai/presentation/task_project/widgets/list_project_add_task.dart';
import 'package:tasklyai/presentation/task_project/widgets/priority_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _deadlineController = TextEditingController();

  @override
  void dispose() {
    _deadlineController.dispose();
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

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
            SizedBox(height: 6),
            Selector<TaskProvider, String>(
              builder: (context, value, child) {
                return ListProjectAddTask(
                  projectSelected: value,
                  onTap: (projectId) {
                    context.read<TaskProvider>().selectProject(projectId);
                  },
                );
              },
              selector: (_, p) => p.projectSelected,
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
            Consumer<TaskProvider>(
              builder: (context, value, child) {
                return PriorityWidget(
                  selected: value.priority,
                  ontap: (priority) {
                    context.read<TaskProvider>().selectPriority(priority);
                  },
                );
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
            AddSubtask(),
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
      initialDate: DateTime.now(),
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
    return DateFormat('MM/dd/yyyy').format(date);
  }

  Widget _buildSave(BuildContext context) {
    final textTheme = context.theme.textTheme;
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
        final isDisable =
            value.priority == null ||
            value.projectSelected.isEmpty ||
            deadline == null ||
            _titleController.text.isEmpty ||
            _descController.text.isEmpty;
        return GestureDetector(
          onTap: isDisable
              ? null
              : () {
                  context.read<TaskProvider>().createTask(
                    context,
                    TaskReq(
                      title: _titleController.text,
                      description: _descController.text,
                      priority: value.priority!.label,
                      dueDate: deadline!,
                      project: value.projectSelected,
                      subtasks: value.subTabs,
                    ),
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
      },
    );
  }
}
