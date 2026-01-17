import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/enum/task_status.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';

class MarkAsComplete extends StatefulWidget {
  const MarkAsComplete(this.task, {super.key});

  final CardModel task;

  @override
  State<MarkAsComplete> createState() => _MarkAsCompleteState();
}

class _MarkAsCompleteState extends State<MarkAsComplete> {
  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return GestureDetector(
      onTap: () {
        context.read<TaskProvider>().updateTask(
          context: context,
          taskId: task.id,
          params: {'status': TaskStatus.completed.label},
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: task.status != TaskStatus.completed
              ? Colors.grey[100]
              : TaskStatus.completed.color.withAlpha(50),
          border: Border.all(
            width: 1.5,
            color: Colors.grey[300] ?? Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          spacing: 8,
          children: [
            Icon(
              task.status != TaskStatus.completed
                  ? Icons.circle_outlined
                  : Icons.check_circle,
              color: task.status != TaskStatus.completed
                  ? Colors.grey
                  : TaskStatus.completed.color,
            ),
            Text(
              'Mark as complete',
              style: context.theme.textTheme.titleSmall?.copyWith(
                color: task.status != TaskStatus.completed
                    ? Colors.black87
                    : TaskStatus.completed.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
