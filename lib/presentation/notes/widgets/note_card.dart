import 'package:flutter/material.dart';
import 'package:tasklyai/models/note_model.dart';
import 'package:tasklyai/presentation/notes/note_detail_screen.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;

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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(note.content, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            // Row(
            //   children: [
            //     _tag(note.category),

            //     const Spacer(),
            //     Text(
            //       Formatter.date(note.createdAt),
            //       style: const TextStyle(color: Colors.grey),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _tag(Category? category) {
  //   if (category == null) {
  //     return SizedBox.shrink();
  //   }
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //     decoration: BoxDecoration(
  //       color: category.color.toColor().withAlpha(38),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Text(
  //       category.name,
  //       style: TextStyle(color: category.color.toColor(), fontSize: 12),
  //     ),
  //   );
  // }
}
