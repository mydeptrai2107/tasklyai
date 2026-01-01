import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tasklyai/presentation/notes/add_note_screen.dart';

class VoiceNoteScreen extends StatefulWidget {
  const VoiceNoteScreen({super.key});

  @override
  State<VoiceNoteScreen> createState() => _VoiceNoteScreenState();
}

class _VoiceNoteScreenState extends State<VoiceNoteScreen> {
  final SpeechToText speech = SpeechToText();
  bool listening = false;
  String text = '';

  @override
  void initState() {
    super.initState();
    speech.initialize();
  }

  void start() {
    setState(() => listening = true);
    speech.listen(
      onResult: (r) {
        setState(() => text = r.recognizedWords);
      },
    );
  }

  void stop() {
    speech.stop();
    setState(() => listening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  text.isEmpty ? 'Start speaking...' : text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: listening ? stop : start,
              child: CircleAvatar(
                radius: 32,
                backgroundColor: listening ? Colors.red : Colors.blue,
                child: Icon(
                  listening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: text.isEmpty
                  ? null
                  : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => AddNoteScreen()),
                      );
                    },
              child: const Text('Use this note'),
            ),
          ],
        ),
      ),
    );
  }
}
