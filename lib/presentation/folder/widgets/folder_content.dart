import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/project_model.dart';
import 'package:tasklyai/presentation/folder/provider/folder_detail_provider.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/note_card.dart';
import 'package:tasklyai/presentation/task_project/provider/project_provider.dart';

class FolderContent extends StatelessWidget {
  const FolderContent({super.key});

  @override
  Widget build(BuildContext context) {
    final detailProvider = context.watch<FolderDetailProvider>();
    final noteProvider = context.watch<NoteProvider>();
    final projectProvider = context.watch<ProjectProvider>();

    switch (detailProvider.filter) {
      case FolderFilterType.all:
        return _AllContent(detailProvider, noteProvider, projectProvider);
      case FolderFilterType.notes:
        return _NotesOnly(noteProvider);
      case FolderFilterType.projects:
        return _ProjectsOnly(projectProvider);
    }
  }
}

class _AllContent extends StatelessWidget {
  final FolderDetailProvider detailProvider;
  final ProjectProvider projectProvider;
  final NoteProvider noteProvider;

  const _AllContent(
    this.detailProvider,
    this.noteProvider,
    this.projectProvider,
  );

  @override
  Widget build(BuildContext context) {
    if (!noteProvider.hasNotes && !projectProvider.hasProjects) {
      return const _EmptyState(text: 'No notes or projects yet');
    }

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (noteProvider.hasNotes) ...[
              const _SectionHeader(title: 'Notes'),
              _NotesGrid(noteProvider.notes),
            ],
            if (projectProvider.hasProjects) ...[
              const _SectionHeader(title: 'Projects'),
              _ProjectsList(projectProvider.project),
            ],
          ],
        ),
      ),
    );
  }
}

class _NotesOnly extends StatelessWidget {
  final NoteProvider provider;

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
  final ProjectProvider provider;

  const _ProjectsOnly(this.provider);

  @override
  Widget build(BuildContext context) {
    if (!provider.hasProjects) {
      return const _EmptyState(text: 'No projects in this folder');
    }

    return _ProjectsList(provider.project);
  }
}

class _NotesGrid extends StatelessWidget {
  final List<CardModel> notes;

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
        return NoteCard(notes[index]);
      },
    );
  }
}

class _ProjectsList extends StatelessWidget {
  final List<ProjectModel> projects;

  const _ProjectsList(this.projects);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: projects
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProjectCard(project: e),
            ),
          )
          .toList(),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

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
              color: Colors.blue.withAlpha(40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.apps, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Text(
            project.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
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

class _CreateNoteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // context.read<FolderProvider>().createFolder();
      },
      icon: const Icon(Icons.add),
      label: const Text('Create note'),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
