import 'package:flutter/material.dart';

class CreateNoteScreen extends StatelessWidget {
  final String content;

  const CreateNoteScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: content);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Edit your note...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (r) => r.isFirst);
              },
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
