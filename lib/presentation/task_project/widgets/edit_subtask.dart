import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/models/task_model.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';

class EditSubtask extends StatefulWidget {
  const EditSubtask(this.subtasks, this.taskId, {super.key});

  final List<Subtask> subtasks;
  final String taskId;

  @override
  State<EditSubtask> createState() => _EditSubtaskState();
}

class _EditSubtaskState extends State<EditSubtask> {
  final _subTask = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subTask.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SubTask', style: textTheme.bodyMedium),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.subtasks.length,
          itemBuilder: (context, index) {
            final subtask = widget.subtasks[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: subtask.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        subtask.isCompleted = value ?? false;
                        update(context, widget.taskId, {
                          'subtasks': widget.subtasks
                              .map((e) => e.toJson())
                              .toList(),
                        });
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  Expanded(
                    child: Text(
                      subtask.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        decoration: subtask.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: subtask.isCompleted
                            ? Colors.grey
                            : textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.subtasks.removeAt(index);
                        update(context, widget.taskId, {
                          'subtasks': widget.subtasks
                              .map((e) => e.toJson())
                              .toList(),
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: AppTextField(
                  controller: _subTask,
                  hint: 'Add subtask...',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Chưa có thông tin';
                    }
                    return null;
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  widget.subtasks.add(
                    Subtask(title: _subTask.text, isCompleted: false),
                  );
                  update(context, widget.taskId, {
                    'subtasks': widget.subtasks.map((e) => e.toJson()).toList(),
                  });
                  _subTask.clear();
                  setState(() {});
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '+',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void update(
    BuildContext context,
    String taskId,
    Map<String, dynamic> params,
  ) {
    context.read<TaskProvider>().updateTask(
      context: context,
      taskId: taskId,
      params: params,
      isShowDialog: false,
    );
  }
}
