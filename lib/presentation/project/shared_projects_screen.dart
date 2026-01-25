import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
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
      appBar: AppBar(title: const Text('Shared with me')),
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
              return _SharedProjectCard(project: items[index], onTap: () {});
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
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
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (project.description.isNotEmpty)
                    Text(
                      project.description,
                      maxLines: 1,
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
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.black45),
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
