import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/widgets/dashed_outline_button.dart';
import 'package:tasklyai/core/widgets/task_empty.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/new_task_screen.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';
import 'package:tasklyai/presentation/project/provider/task_provider.dart';
import 'package:tasklyai/presentation/project/update_project_screen.dart';
import 'package:tasklyai/presentation/project/widgets/task_item.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen(this.project, {super.key});

  final ProjectModel project;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late ProjectModel _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTaskByProject(_project.id);
    });
  }

  Color get _color => Color(_project.color);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text('Project Detail', style: context.theme.textTheme.titleMedium),
        actions: [
          PopupMenuButton<_ProjectAction>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == _ProjectAction.edit) {
                _editProject();
              } else if (value == _ProjectAction.delete) {
                _deleteProject();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _ProjectAction.edit,
                child: _MenuItem(icon: Icons.edit_outlined, text: 'Edit'),
              ),
              PopupMenuItem(
                value: _ProjectAction.delete,
                child: _MenuItem(
                  icon: Icons.delete_outline,
                  text: 'Delete',
                  isDanger: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _projectHeader(textTheme),
          const SizedBox(height: 8),
          _taskSection(),
          _addTaskButton(),
        ],
      ),
    );
  }

  /// HEADER
  Widget _projectHeader(TextTheme textTheme) {
    final project = _project;

    final progress = project.totalTasks == 0
        ? 0.0
        : project.completedTasks / project.totalTasks;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _color.withAlpha(25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  IconData(project.icon, fontFamily: 'MaterialIcons'),
                  color: _color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (project.description.isNotEmpty)
                      Text(
                        project.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              _statusBadge(),
            ],
          ),

          const SizedBox(height: 16),

          /// PROGRESS
          Row(
            children: [
              Text(
                '${project.completedTasks}/${project.totalTasks} tasks',
                style: textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                '${project.completionRate}%',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: _color.withAlpha(40),
              color: _color,
            ),
          ),
        ],
      ),
    );
  }

  /// TASK LIST
  Widget _taskSection() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Consumer<TaskProvider>(
          builder: (context, provider, _) {
            if (provider.taskByProject.isEmpty) {
              return TaskEmpty(_project);
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.taskByProject.length,
              separatorBuilder: (_, child) => SizedBox(height: 8),
              itemBuilder: (context, index) {
                return TaskItem(provider.taskByProject[index]);
              },
            );
          },
        ),
      ),
    );
  }

  /// ADD TASK BUTTON
  Widget _addTaskButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: DashedOutlineButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewTaskScreen(_project)),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: _color),
            const SizedBox(width: 6),
            Text(
              'Add Task',
              style: context.theme.textTheme.titleSmall?.copyWith(
                color: _color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// STATUS BADGE
  Widget _statusBadge() {
    final project = _project;

    Color bg;
    Color text;
    String label;

    if (project.completedTasks == project.totalTasks &&
        project.totalTasks > 0) {
      bg = Colors.green.withAlpha(30);
      text = Colors.green;
      label = 'Done';
    } else if (project.isOverdue) {
      bg = Colors.red.withAlpha(30);
      text = Colors.red;
      label = 'Overdue';
    } else {
      bg = _color.withAlpha(30);
      text = _color;
      label = 'Active';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }

  Future<void> _editProject() async {
    final updated = await Navigator.push<ProjectModel>(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateProjectScreen(project: _project),
      ),
    );
    if (!mounted) return;
    if (updated != null) {
      setState(() => _project = updated);
    }
  }

  void _deleteProject() {
    DialogService.confirm(
      context,
      message: 'Ban co chac chan muon xoa project?',
      onConfirm: () async {
        await context.read<ProjectProvider>().deleteProject(
              context,
              _project.areaId,
              _project.id,
            );
        if (!context.mounted) return;
        Navigator.pop(context, true);
      },
    );
  }
}

enum _ProjectAction { edit, delete }

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDanger;

  const _MenuItem({
    required this.icon,
    required this.text,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger ? Colors.red : Colors.black87;
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
