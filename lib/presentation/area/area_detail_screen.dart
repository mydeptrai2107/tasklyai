import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';
import 'package:tasklyai/presentation/folder/widgets/folder_list.dart';
import 'package:tasklyai/presentation/project/provider/project_provider.dart';
import 'package:tasklyai/presentation/project/widgets/project_list.dart';

class AreaDetailScreen extends StatefulWidget {
  const AreaDetailScreen(this.item, {super.key});

  final AreaModel item;

  @override
  State<AreaDetailScreen> createState() => _AreaDetailScreenState();
}

class _AreaDetailScreenState extends State<AreaDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FolderProvider>().fetchFolder(widget.item.id);
      context.read<ProjectProvider>().fetchProjectByArea(widget.item.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Column(
          children: [
            _Header(widget.item),
            _Tabs(),
            Expanded(
              child: TabBarView(
                children: [
                  /// TAB FOLDERS
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FolderList(areaModel: widget.item),
                  ),

                  /// TAB PROJECTS (fake)
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: ProjectList(item: widget.item),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Color(0xFF4C7EFF),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        labelColor: Colors.white,
        splashBorderRadius: BorderRadius.all(Radius.circular(14)),
        unselectedLabelColor: Colors.black54,
        dividerHeight: 0,
        tabs: [
          Tab(text: 'Folders'),
          Tab(text: 'Projects'),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.item);

  final AreaModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Color(item.color),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_HeaderAppBar(item.id), _AreaInfo(item), _StatsRow(item)],
      ),
    );
  }
}

enum _HeaderAction { edit, delete }

class _HeaderAppBar extends StatelessWidget {
  final String areaId;

  const _HeaderAppBar(this.areaId);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(color: Colors.white),
        Spacer(),
        PopupMenuButton<_HeaderAction>(
          icon: Icon(Icons.more_vert, color: Colors.white),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case _HeaderAction.edit:
                break;
              case _HeaderAction.delete:
                DialogService.confirm(
                  context,
                  message: 'Bạn có chắc chắn muốn xóa?',
                  onConfirm: () {
                    context.read<AreaProvider>().deleteArea(context, areaId);
                  },
                );
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _HeaderAction.edit,
              child: _MenuItem(icon: Icons.edit_outlined, text: 'Edit'),
            ),
            PopupMenuItem(
              value: _HeaderAction.delete,
              child: _MenuItem(
                icon: Icons.delete_outline,
                text: 'Delete',
                isDanger: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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

class _AreaInfo extends StatelessWidget {
  const _AreaInfo(this.item);

  final AreaModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(60),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconInt(icon: item.icon, color: Colors.white.toARGB32()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                item.description,
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow(this.item);

  final AreaModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatBox(label: 'Folders', value: item.folderCount.toString()),
        _StatBox(label: 'Projects', value: item.projectCount.toString()),
        _StatBox(label: 'Notes', value: item.noteCount.toString()),
        _StatBox(label: 'Tasks', value: item.folderCount.toString()),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
