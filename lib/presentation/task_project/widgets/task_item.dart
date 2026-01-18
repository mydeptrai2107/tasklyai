import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';
import 'package:tasklyai/presentation/task_project/task_detail_screen.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.task, {super.key});

  final CardModel task;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await _confirmDelete(context, task);
      },
      onDismissed: (_) {},
      background: _deleteBackground(),
      child: InkWell(
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
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: task.energyLevel.color),
                  const SizedBox(width: 8),
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
                  children: [
                    const Icon(Icons.folder, size: 16, color: Colors.amber),
                    const SizedBox(width: 6),
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

  /// BACKGROUND DELETE
  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.delete, color: Colors.white, size: 28),
    );
  }

  /// CONFIRM DIALOG
  Future<bool> _confirmDelete(BuildContext context, CardModel card) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete task?'),
            content: const Text('This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<TaskProvider>().deleteTask(context, card);
                  return Navigator.pop(context, true);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
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
