import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';

class ListProjectAddTask extends StatelessWidget {
  const ListProjectAddTask({
    super.key,
    required this.projectSelected,
    required this.onTap,
  });

  final String projectSelected;
  final Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Consumer<ProjectProvider>(
      builder: (context, projectValue, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: projectValue.projectsArea.length,
            itemBuilder: (context, index) {
              final project = projectValue.projectsArea[index];
              return GestureDetector(
                onTap: () {
                  onTap.call(project.id);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: projectSelected == project.id
                        ? primaryColor.withAlpha(20)
                        : null,
                    border: Border.all(
                      width: 1.5,
                      color: projectSelected == project.id
                          ? primaryColor
                          : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(project.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(project.name, style: textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
