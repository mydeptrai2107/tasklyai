import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';

class AddSubtask extends StatefulWidget {
  const AddSubtask({super.key, required this.onChange});

  final Function(List<String> value) onChange;

  @override
  State<AddSubtask> createState() => _AddSubtaskState();
}

class _AddSubtaskState extends State<AddSubtask> {
  final _subTaskController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _subTasks = [];

  @override
  void dispose() {
    _subTaskController.dispose();
    super.dispose();
  }

  void _addSubTask() {
    if (!_formKey.currentState!.validate()) return;

    final value = _subTaskController.text.trim();
    if (value.isEmpty) return;

    setState(() {
      _subTasks.add(value);
    });

    widget.onChange(_subTasks);
    _subTaskController.clear();
  }

  void _removeSubTask(int index) {
    setState(() {
      _subTasks.removeAt(index);
    });

    widget.onChange(_subTasks);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Subtask', style: textTheme.bodyMedium),
        const SizedBox(height: 8),

        /// LIST SUBTASK
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _subTasks.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _subTasks[index],
                      style: textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeSubTask(index),
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

        const SizedBox(height: 8),

        /// INPUT ADD SUBTASK
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: AppTextField(
                    controller: _subTaskController,
                    hint: 'Add subtask...',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Chưa có thông tin';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _addSubTask,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '+',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
