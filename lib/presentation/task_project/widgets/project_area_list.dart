import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/project_item.dart';

class ProjectAreaList extends StatelessWidget {
  const ProjectAreaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectProvider, List<ProjectModel>>(
      builder: (context, value, child) {
        return ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            return ProjectItem(value[index]);
          },
        );
      },
      selector: (_, p) => p.projectsArea,
    );
  }
}
