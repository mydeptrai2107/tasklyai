import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/task_project/project_detail_screen.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem(this.project, {super.key});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProjectDetailScreen(project);
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: project.color.toColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(project.name, style: textTheme.titleSmall),
                ),
                Icon(
                  Icons.check_circle,
                  color: project.color.toColor(),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${project.taskStats.completed} / ${project.taskStats.total} tasks',
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: project.taskStats.process(),
              backgroundColor: project.color.toColor().withAlpha(51),
              color: project.color.toColor(),
              minHeight: 6,
            ),
            const SizedBox(height: 6),
            const Text('View tasks', style: TextStyle(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}
