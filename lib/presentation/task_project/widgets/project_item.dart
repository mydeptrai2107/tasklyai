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
                    color: Color(project.color),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(project.name, style: textTheme.titleSmall),
                ),
                Icon(Icons.check_circle, color: Color(project.color), size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text('${project.completedTasks} / ${project.totalTasks} tasks'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: project.completedTasks.toDouble(),
              backgroundColor: Color(project.color).withAlpha(51),
              color: Color(project.color),
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
