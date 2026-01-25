import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/dashed_outline_button.dart';
import 'package:tasklyai/core/widgets/project_empty.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/new_project_screen.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';
import 'package:tasklyai/presentation/project/widgets/project_item.dart';

class ProjectList extends StatelessWidget {
  const ProjectList({super.key, this.item, this.searchQuery = ''});

  final AreaModel? item;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Selector<ProjectProvider, List<ProjectModel>>(
      builder: (context, value, child) {
        final query = searchQuery.trim().toLowerCase();
        final filtered = query.isEmpty
            ? value
            : value.where((project) {
                final name = project.name.toLowerCase();
                final desc = project.description.toLowerCase();
                return name.contains(query) || desc.contains(query);
              }).toList();

        if (filtered.isEmpty) {
          if (value.isEmpty) {
            return ProjectEmpty(areaModel: item);
          }
          return const Center(
            child: Text(
              'No projects found.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ProjectItem(filtered[index]);
                },
              ),
            ),
            const SizedBox(height: 15),
            DashedOutlineButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewProjectScreen(areaModel: item),
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
      selector: (_, p) => p.allProjects,
    );
  }
}
