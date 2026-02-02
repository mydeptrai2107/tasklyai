import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/checklist_item.dart';
import 'package:tasklyai/presentation/notes/widgets/add_checklist_widget.dart';
import 'package:tasklyai/presentation/project/provider/task_provider.dart';

class EditSubtask extends StatelessWidget {
  const EditSubtask(this.subtasks, this.task, {super.key});

  final List<ChecklistItem> subtasks;
  final CardModel task;

  @override
  Widget build(BuildContext context) {
    return AddCheckListWidget(
      title: 'Subtask',
      initValue: subtasks,
      onChanged: (value) {
        context.read<TaskProvider>().updateTask(
          isShowDialog: false,
          context: context,
          taskId: task.id,
          areaId: task.area?.id,
          projectId: task.project?.id,
          params: {'checklist': value.map((e) => e.toJson()).toList()},
        );
      },
    );
  }
}
