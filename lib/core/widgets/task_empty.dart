import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/new_task_screen.dart';

class TaskEmpty extends StatelessWidget {
  const TaskEmpty(this.projectModel, {super.key});

  final ProjectModel projectModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              size: 36,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tasks yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Create your first task to stay productive',
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewTaskScreen(projectModel: projectModel),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Task'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
