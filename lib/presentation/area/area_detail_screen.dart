import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_provider.dart';
import 'package:tasklyai/presentation/folder/widgets/folder_list.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';
import 'package:tasklyai/presentation/task_project/widgets/project_area_list.dart';

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
                    child: FolderList(widget.item),
                  ),

                  /// TAB PROJECTS (fake)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ProjectAreaList(),
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
      margin: const EdgeInsets.all(16),
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
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Color(item.color),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderAppBar(),
          const SizedBox(height: 20),
          _AreaInfo(item),
          const SizedBox(height: 20),
          _StatsRow(item),
        ],
      ),
    );
  }
}

class _HeaderAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        BackButton(color: Colors.white),
        Spacer(),
        Icon(Icons.more_vert, color: Colors.white),
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
