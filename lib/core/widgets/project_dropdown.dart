import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';

class ProjectDropdown extends StatefulWidget {
  final ValueChanged<ProjectModel?> onChanged;
  final ProjectModel? initValue;
  final String placeholder;
  final bool includeNone;

  const ProjectDropdown({
    super.key,
    required this.onChanged,
    this.initValue,
    this.placeholder = 'Select project',
    this.includeNone = true,
  });

  @override
  State<ProjectDropdown> createState() => _ProjectDropdownState();
}

class _ProjectDropdownState extends State<ProjectDropdown> {
  ProjectModel? projectSelected;

  @override
  void initState() {
    projectSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().allProjects;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showBottomSheet(context, projects),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (projectSelected != null)
              IconInt(
                icon: projectSelected!.icon,
                color: projectSelected!.color,
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                projectSelected?.name ?? widget.placeholder,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color:
                      projectSelected == null ? Colors.black54 : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, List<ProjectModel> projects) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        if (projects.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('No projects available.'),
          );
        }
        final total = projects.length + (widget.includeNone ? 1 : 0);
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: total,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, index) {
            if (widget.includeNone && index == 0) {
              return ListTile(
                leading: const Icon(Icons.block),
                title: const Text(
                  'No project',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onChanged(null);
                  projectSelected = null;
                  setState(() {});
                },
              );
            }
            final projectIndex = widget.includeNone ? index - 1 : index;
            final project = projects[projectIndex];
            return ListTile(
              leading: IconInt(icon: project.icon, color: project.color),
              title: Text(
                project.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                project.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onChanged(project);
                projectSelected = project;
                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}
