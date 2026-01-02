import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/task_project/provider/task_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/task_item.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen(this.project, {super.key});

  final ProjectModel project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TaskProvider>().fetchTaskByProject(widget.project.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final project = widget.project;

    return Scaffold(
      appBar: AppBar(
        title: Text('Project Detail', style: textTheme.titleSmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: project.color.toColor(),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(project.name, style: textTheme.titleMedium),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${project.taskStats.completed} / ${project.taskStats.total} tasks completed',
              ),
            ),
            LinearProgressIndicator(
              value: project.taskStats.process(),
              backgroundColor: project.color.toColor().withAlpha(51),
              color: project.color.toColor(),
              minHeight: 6,
            ),
            SizedBox(height: 10),

            Consumer<TaskProvider>(
              builder: (context, value, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: value.taskByProject.length,
                    itemBuilder: (context, index) {
                      return TaskItem(value.taskByProject[index]);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
