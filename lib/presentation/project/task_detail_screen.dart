import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/checklist_item.dart';
import 'package:tasklyai/presentation/project/provider/task_provider.dart';
import 'package:tasklyai/presentation/project/widgets/edit_subtask.dart';
import 'package:tasklyai/presentation/project/widgets/list_project_add_task.dart';
import 'package:tasklyai/presentation/project/widgets/priority_widget.dart';
import 'package:tasklyai/presentation/project/widgets/task_status_widget.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen(this.task, {super.key});

  final CardModel task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _deadlineController;
  late Priority prioritySelected;
  late String projectSelected;
  late List<ChecklistItem> subtasks;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.content);
    _deadlineController = TextEditingController(
      text: Formatter.dateJson(widget.task.dueDate ?? DateTime.now()),
    );
    prioritySelected = widget.task.energyLevel;
    projectSelected = widget.task.project!.id;
    subtasks = widget.task.checklist;

    super.initState();
  }

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
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details', style: textTheme.titleMedium),
        centerTitle: true,
        actions: [_buildArchive(context, task), _buildSave(context, task)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskStatusWidget(task),
            // task title
            Text('Task Title', style: textTheme.bodyMedium),
            SizedBox(height: 6),
            AppTextField(
              controller: _titleController,
              hint: 'Enter task title...',
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 16),

            // description
            Text('Description', style: textTheme.bodyMedium),
            SizedBox(height: 6),
            AppTextField(
              controller: _descController,
              hint: 'Add details about this task...',
              maxLines: 4,
              onChanged: (value) {
                setState(() {});
              },
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
            ListProjectAddTask(
              initProject: projectSelected,
              onTap: (value) {
                setState(() {
                  update(context, task.id, {'projectId': value});
                });
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
                update(context, task.id, {
                  "energyLevel": priority.eng.toLowerCase(),
                });
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
              onTap: () {
                pickDate(context: context, task: task, isStart: false);
              },
              child: AbsorbPointer(
                child: AppTextField(
                  controller: _deadlineController,
                  hint: 'dd/MM/yyyy',
                ),
              ),
            ),
            SizedBox(height: 16),

            // sub task
            EditSubtask(subtasks, task),
          ],
        ),
      ),
    );
  }

  void update(
    BuildContext context,
    String taskId,
    Map<String, dynamic> params, {
    bool isShowDialog = false,
  }) {
    context.read<TaskProvider>().updateTask(
      isShowDialog: isShowDialog,
      context: context,
      taskId: taskId,
      areaId: widget.task.area?.id,
      projectId: widget.task.project?.id,
      params: params,
    );
  }

  DateTime? deadline;

  Future<void> pickDate({
    required BuildContext context,
    required CardModel task,
    required bool isStart,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: task.dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        deadline = picked;
        _deadlineController.text = Formatter.dateJson(deadline!);
        update(context, task.id, {"dueDate": deadline!.toIso8601String()});
      });
    }
  }

  Widget _buildSave(BuildContext context, CardModel task) {
    final textTheme = context.theme.textTheme;
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
        final isDisable =
            _titleController.text.trim() == task.title &&
            _descController.text.trim() == task.content;
        return GestureDetector(
          onTap: () {
            if (!isDisable) {
              update(context, task.id, {
                "title": _titleController.text.trim(),
                "content": _descController.text.trim(),
              }, isShowDialog: true);
            }
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

  Widget _buildArchive(BuildContext context, CardModel task) {
    return IconButton(
      tooltip: task.isArchived ? 'Unarchive' : 'Archive',
      icon: Icon(task.isArchived ? Icons.unarchive : Icons.archive_outlined),
      onPressed: () async {
        final provider = context.read<TaskProvider>();
        if (task.isArchived) {
          await provider.unarchiveTask(context, task);
        } else {
          await provider.archiveTask(context, task);
        }
        if (!mounted) return;
        Navigator.pop(context);
      },
    );
  }
}
