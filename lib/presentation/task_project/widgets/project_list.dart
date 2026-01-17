import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/dashed_outline_button.dart';
import 'package:tasklyai/core/widgets/project_empty.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/task_project/new_project_screen.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/project_item.dart';

class ProjectList extends StatelessWidget {
  const ProjectList(this.item, {super.key});

  final AreaModel item;

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectProvider, List<ProjectModel>>(
      builder: (context, value, child) {
        if (value.isEmpty) {
          return ProjectEmpty(item);
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return ProjectItem(value[index]);
                },
              ),
            ),
            DashedOutlineButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewProjectScreen(item),
                  ),
                );
              },
              child: Text(
                'Add New Project',
                style: context.theme.textTheme.titleSmall,
              ),
            ),
          ],
        );
      },
      selector: (_, p) => p.projectsArea,
    );
  }
}
