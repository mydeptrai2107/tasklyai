import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/enum/task_status.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/project/provider/task_provider.dart';

class TaskStatusWidget extends StatefulWidget {
  const TaskStatusWidget(this.task, {super.key});

  final CardModel task;

  @override
  State<TaskStatusWidget> createState() => _TaskStatusWidgetState();
}

class _TaskStatusWidgetState extends State<TaskStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TaskStatus.values.map((e) {
          return InkWell(
            onTap: () {
              context.read<TaskProvider>().updateTask(
                context: context,
                taskId: widget.task.id,
                areaId: widget.task.area?.id,
                projectId: widget.task.project?.id,
                params: {'status': e.eng},
              );
              widget.task.status = e;
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(right: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.task.status == e ? e.color : null,
                border: Border.all(width: 1, color: e.color),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(e.label, style: textTheme.bodySmall),
            ),
          );
        }).toList(),
      ),
    );
  }
}
