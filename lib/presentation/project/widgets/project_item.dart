import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/project_detail_screen.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem(this.project, {super.key});

  final ProjectModel project;

  Color get _color => Color(project.color);

  bool get _isDone =>
      project.totalTasks > 0 && project.completedTasks == project.totalTasks;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProjectDetailScreen(project)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(textTheme),
            const SizedBox(height: 12),
            _description(textTheme),
            const SizedBox(height: 14),
            _progress(textTheme),
            const SizedBox(height: 10),
            _footer(textTheme),
          ],
        ),
      ),
    );
  }

  /// HEADER: Icon + Name + Status
  Widget _header(TextTheme textTheme) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: IconInt(icon: project.icon, color: project.color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            project.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        _statusBadge(),
      ],
    );
  }

  /// DESCRIPTION
  Widget _description(TextTheme textTheme) {
    if (project.description.isEmpty) return const SizedBox();

    return Text(
      project.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
    );
  }

  /// PROGRESS
  Widget _progress(TextTheme textTheme) {
    final progress = project.totalTasks == 0
        ? 0.0
        : project.completedTasks / project.totalTasks;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }

  /// FOOTER
  Widget _footer(TextTheme textTheme) {
    return Row(
      children: [
        Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          '${project.duration} days',
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        const Spacer(),
        Text(
          'View details',
          style: textTheme.bodySmall?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// STATUS BADGE
  Widget _statusBadge() {
    Color bg;
    Color text;
    String label;

    if (_isDone) {
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
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
