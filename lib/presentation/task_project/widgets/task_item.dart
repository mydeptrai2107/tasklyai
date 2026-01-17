import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/task_project/task_detail_screen.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.task, {super.key});

  final CardModel task;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskDetailScreen(task)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 8,
                children: [
                  Icon(Icons.circle, size: 10, color: task.energyLevel.color),
                  Expanded(
                    child: Text(task.title, style: textTheme.titleSmall),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                task.content,
                style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.folder, color: Colors.amberAccent, size: 16),
                    Text(task.folder?.name ?? '', style: textTheme.bodyMedium),
                  ],
                ),
              ),
              Wrap(
                spacing: 8,
                children: [
                  _tag(
                    '⏰ ${Formatter.date(task.dueDate ?? DateTime.now())}',
                    Colors.red,
                  ),
                  _tag(task.energyLevel.label, task.energyLevel.color),
                  _tag(task.status.label, task.status.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
