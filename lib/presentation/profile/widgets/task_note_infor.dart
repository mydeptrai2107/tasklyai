import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/enum/task_status.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/task_model.dart';

class TaskNoteInfor extends StatelessWidget {
  const TaskNoteInfor({super.key, required this.notes, required this.tasks});

  final List<CardModel> notes;
  final List<TaskModel> tasks;

  @override
  Widget build(BuildContext context) {
    final inProcess = tasks
        .where((e) => e.status == TaskStatus.inProgress)
        .fold(0, (sum, element) => sum + 1);

    final complete = tasks
        .where((e) => e.status == TaskStatus.completed)
        .fold(0, (sum, element) => sum + 1);

    final note = notes.length;

    final textTheme = context.theme.textTheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 6,
              children: [
                Text(
                  '🔥 $inProcess',
                  style: textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                Text(
                  'In Progress',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: Colors.white),
          Expanded(
            child: Column(
              spacing: 6,
              children: [
                Text(
                  '✅ $complete',
                  style: textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                Text(
                  'Completed',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: Colors.white),
          Expanded(
            child: Column(
              spacing: 6,
              children: [
                Text(
                  '📝 $note',
                  style: textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                Text(
                  'Notes',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
