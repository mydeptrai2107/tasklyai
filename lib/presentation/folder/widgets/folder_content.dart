import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/notes/create_note_screen.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/note_card.dart';

class FolderContent extends StatelessWidget {
  const FolderContent({
    super.key,
    required this.folder,
    required this.areaModel,
  });

  final FolderModel folder;
  final AreaModel areaModel;

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    return _NotesOnly(noteProvider, folder);
  }
}

class _NotesOnly extends StatelessWidget {
  final NoteProvider provider;
  final FolderModel folder;

  const _NotesOnly(this.provider, this.folder);

  @override
  Widget build(BuildContext context) {
    if (!provider.hasNotes) {
      return _EmptyState(text: 'No notes in this folder', folder: folder);
    }

    return _NotesGrid(provider.notes, folder);
  }
}

class _NotesGrid extends StatelessWidget {
  final List<CardModel> notes;
  final FolderModel folder;

  const _NotesGrid(this.notes, this.folder);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionHeader(title: 'Notes', onAdd: () {}),
        Expanded(
          child: GridView.builder(
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
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  final FolderModel folder;

  const _EmptyState({required this.text, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        Text(text, style: TextStyle(color: Colors.grey.shade600)),
        _CreateNoteButton(folder),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;

  const _SectionHeader({required this.title, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
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
  final FolderModel folder;

  const _CreateNoteButton(this.folder);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CreateNoteScreen(folder);
            },
          ),
        );
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
