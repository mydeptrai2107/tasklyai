import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_detail_provider.dart';
import 'package:tasklyai/presentation/folder/widgets/folder_content.dart';
import 'package:tasklyai/presentation/folder/widgets/folder_filter_tabs.dart';

class FolderDetailScreen extends StatelessWidget {
  final FolderModel folder;

  const FolderDetailScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _Header(folder: folder),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _SearchBox(),
                  const SizedBox(height: 12),
                  ChangeNotifierProvider(
                    create: (_) => FolderDetailProvider(),
                    child: Column(
                      children: [
                        FolderFilterTabs(folder: folder),
                        SizedBox(height: 16),
                        FolderContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final FolderModel folder;

  const _Header({required this.folder});

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
        color: Color(folder.color),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderAppBar(),
          const SizedBox(height: 16),
          _FolderInfo(folder: folder),
          const SizedBox(height: 16),
          _Stats(folder: folder),
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

class _FolderInfo extends StatelessWidget {
  final FolderModel folder;

  const _FolderInfo({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(65),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconInt(icon: folder.icon, color: Colors.white.toARGB32()),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                folder.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                folder.description,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 6),
              // _AreaTag(folder),
            ],
          ),
        ),
      ],
    );
  }
}

class _AreaTag extends StatelessWidget {
  final FolderModel folder;

  const _AreaTag(this.folder);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconInt(icon: folder.icon, size: 14, color: Colors.white.toARGB32()),
          SizedBox(width: 6),
          Text(
            folder.name,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final FolderModel folder;

  const _Stats({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(label: 'Notes', value: folder.noteCount),
        const SizedBox(width: 12),
        _StatBox(label: 'Projects', value: folder.projectCount),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;

  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search in this folder...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
