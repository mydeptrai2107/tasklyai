import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/core/configs/formater.dart';
import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';
import 'package:tasklyai/presentation/project/project_detail_screen.dart';

class SharedProjectsScreen extends StatefulWidget {
  const SharedProjectsScreen({super.key});

  @override
  State<SharedProjectsScreen> createState() => _SharedProjectsScreenState();
}

class _SharedProjectsScreenState extends State<SharedProjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().fetchSharedWithMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Shared with me'),
        elevation: 0,
      ),
      body: Consumer<ProjectProvider>(
        builder: (context, provider, _) {
          final items = provider.sharedWithMe;
          if (items.isEmpty) {
            return const Center(child: Text('No shared projects yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _SharedProjectCard(
                project: items[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailScreen(items[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SharedProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const _SharedProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(project.color);
    final tasks = project.cards;
    final previewTasks = tasks.take(3).toList();
    final avatarUrl = _avatarUrl(project.ownerAvatarUrl);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    IconData(project.icon, fontFamily: 'MaterialIcons'),
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      if (project.description.isNotEmpty)
                        Text(
                          project.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                _PermissionBadge(permission: project.permission ?? 'view'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Text(
                          _initials(project.ownerName),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Shared by ${project.ownerName ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ),
                if (project.sharedAt != null)
                  Text(
                    Formatter.timeAgo(project.sharedAt!),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black45,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${project.completedTasks}/${project.totalTasks} tasks',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const Spacer(),
                Text(
                  '${project.completionRate}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: project.totalTasks == 0
                    ? 0
                    : project.completedTasks / project.totalTasks,
                minHeight: 6,
                backgroundColor: color.withAlpha(35),
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            if (previewTasks.isEmpty)
              const Text(
                'No tasks shared yet.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              )
            else
              Column(
                children: [
                  for (final task in previewTasks)
                    _TaskPreviewRow(task: task),
                ],
              ),
            if (tasks.length > previewTasks.length)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '+${tasks.length - previewTasks.length} more tasks',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: Colors.black45, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionBadge extends StatelessWidget {
  final String permission;

  const _PermissionBadge({required this.permission});

  @override
  Widget build(BuildContext context) {
    final isOwner = permission == 'owner';
    final color = isOwner ? Colors.green : primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        permission,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TaskPreviewRow extends StatelessWidget {
  final CardModel task;

  const _TaskPreviewRow({required this.task});

  @override
  Widget build(BuildContext context) {
    final dueText =
        task.dueDate != null ? Formatter.date(task.dueDate!) : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: task.status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          if (dueText != null)
            Text(
              dueText,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
        ],
      ),
    );
  }
}

String? _avatarUrl(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  if (raw.startsWith('http')) return raw;
  return '$baseUrl$raw';
}

String _initials(String? name) {
  final trimmed = (name ?? '').trim();
  if (trimmed.isEmpty) return 'U';
  return trimmed[0].toUpperCase();
}
