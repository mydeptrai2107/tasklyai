import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/app_text_field.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';

class AddSubtask extends StatefulWidget {
  const AddSubtask({super.key});

  @override
  State<AddSubtask> createState() => _AddSubtaskState();
}

class _AddSubtaskState extends State<AddSubtask> {
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
        Selector<TaskProvider, List<String>>(
          builder: (context, value, child) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 6),
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        value[index],
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<TaskProvider>().removeSubTab(
                            value[index],
                          );
                        },
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          selector: (_, p) => p.subTabs,
        ),
        IntrinsicHeight(
          child: Row(
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
                    context.read<TaskProvider>().addSubTab(_subTask.text);
                    _subTask.clear();
                  }
                },
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
