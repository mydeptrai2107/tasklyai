import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/models/folder_model.dart';
import 'package:tasklyai/presentation/notes/create_note_screen.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';
import 'package:tasklyai/presentation/notes/widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen(this.folderModel, {super.key});

  final FolderModel folderModel;

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchNote(widget.folderModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateNoteScreen(folderModel: widget.folderModel),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              _search(),
              Expanded(child: _noteList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Selector<NoteProvider, int>(
      selector: (_, p) => p.notes.length,
      builder: (context, count, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Text(
                '$count notes',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                widget.folderModel.name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search notes...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _noteList() {
    return Selector<NoteProvider, List<CardModel>>(
      builder: (context, value, child) {
        return ListView.separated(
          itemCount: value.length,
          itemBuilder: (context, index) => NoteCard(value[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 6),
        );
      },
      selector: (context, p) => p.notes,
    );
  }
}
