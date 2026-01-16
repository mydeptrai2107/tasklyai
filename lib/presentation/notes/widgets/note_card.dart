import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/notes/note_detail_screen.dart';

class NoteCard extends StatelessWidget {
  final CardModel note;

  const NoteCard(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoteDetailScreen(note)),
        );
      },
      child: Container(
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
            Text(note.title, style: context.theme.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
