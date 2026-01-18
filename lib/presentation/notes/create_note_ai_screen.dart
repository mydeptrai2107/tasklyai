import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/presentation/notes/widgets/voice_to_note_bottom_sheet.dart';
import 'package:tasklyai/presentation/task_project/provider/ai_provider.dart';

class CreateNoteAIScreen extends StatefulWidget {
  const CreateNoteAIScreen({super.key});

  @override
  State<CreateNoteAIScreen> createState() => _CreateNoteAIScreenState();
}

class _CreateNoteAIScreenState extends State<CreateNoteAIScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Note', style: textTheme.titleSmall),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _inputCard(context),
            const SizedBox(height: 16),
            _aiActions(context),
            const Spacer(),
            _analyzeButton(context),
          ],
        ),
      ),
    );
  }

  Widget _inputCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
      ),
      child: TextField(
        controller: _controller,
        maxLines: 6,
        decoration: const InputDecoration(
          hintText: 'Write something or use AI...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _aiActions(BuildContext context) {
    return Row(
      children: [
        _actionIcon(Icons.mic_rounded, 'Voice'),
        const SizedBox(width: 12),
        _actionIcon(Icons.image_rounded, 'Image'),
        const SizedBox(width: 12),
        _actionIcon(Icons.auto_awesome, 'AI'),
      ],
    );
  }

  Widget _actionIcon(IconData icon, String label) {
    return Expanded(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => VoiceToNoteBottomSheet(
              onChange: (value) {
                _controller.text = value;
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blueAccent.withAlpha(22),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.blueAccent),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _analyzeButton(BuildContext context) {
    return Consumer<AiProvider>(
      builder: (context, value, child) {
        return ElevatedButton.icon(
          icon: value.aiIsLoading
              ? Center(child: CircularProgressIndicator())
              : Icon(Icons.auto_awesome),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: value.aiIsLoading
              ? null
              : () {
                  context.read<AiProvider>().quickNoteFromAI(
                    context,
                    _controller.text,
                  );
                },
          label: const Text('Analyze with AI'),
        );
      },
    );
  }
}
