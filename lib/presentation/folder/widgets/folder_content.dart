import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/presentation/folder/provider/folder_detail_provider.dart';

class FolderContent extends StatelessWidget {
  const FolderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FolderDetailProvider>();

    switch (provider.filter) {
      case FolderFilterType.all:
        return _AllContent(provider);
      case FolderFilterType.notes:
        return _NotesOnly(provider);
      case FolderFilterType.projects:
        return _ProjectsOnly(provider);
    }
  }
}

class _AllContent extends StatelessWidget {
  final FolderDetailProvider provider;

  const _AllContent(this.provider);

  @override
  Widget build(BuildContext context) {
    if (!provider.hasNotes && !provider.hasProjects) {
      return const _EmptyState(text: 'No notes or projects yet');
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (provider.hasNotes) ...[
            const _SectionHeader(title: 'Notes'),
            _NotesGrid(provider.notes),
          ],
          // if (provider.hasProjects) ...[
          //   const _SectionHeader(title: 'Projects'),
          //   _ProjectsList(provider.projects),
          // ],
        ],
      ),
    );
  }
}

class _NotesOnly extends StatelessWidget {
  final FolderDetailProvider provider;

  const _NotesOnly(this.provider);

  @override
  Widget build(BuildContext context) {
    if (!provider.hasNotes) {
      return const _EmptyState(text: 'No notes in this folder');
    }

    return _NotesGrid(provider.notes);
  }
}

class _ProjectsOnly extends StatelessWidget {
  final FolderDetailProvider provider;

  const _ProjectsOnly(this.provider);

  @override
  Widget build(BuildContext context) {
    if (!provider.hasProjects) {
      return const _EmptyState(text: 'No projects in this folder');
    }

    return _ProjectsList(provider.projects);
  }
}

class _NotesGrid extends StatelessWidget {
  final List<String> notes;

  const _NotesGrid(this.notes);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemCount: notes.length,
      itemBuilder: (_, index) {
        return _NoteCard(title: notes[index]);
      },
    );
  }
}

class _ProjectsList extends StatelessWidget {
  final List<String> projects;

  const _ProjectsList(this.projects);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: projects
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProjectCard(title: e),
            ),
          )
          .toList(),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;

  const _NoteCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.description, color: Colors.orange),
          Text(title, style: context.theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;

  const _ProjectCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.apps, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text(text, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAdd;

  const _SectionHeader({required this.title, this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (onAdd != null)
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}
