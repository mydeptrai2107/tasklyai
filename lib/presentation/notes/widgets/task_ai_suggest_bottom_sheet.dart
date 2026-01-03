import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/presentation/notes/widgets/ai_task_item.dart';
import 'package:tasklyai/presentation/task_project/provider/ai_provider.dart';

class TaskAiSuggestBottomSheet extends StatefulWidget {
  const TaskAiSuggestBottomSheet({
    super.key,
    required this.text,
    required this.controller,
  });

  final String text;
  final ScrollController? controller;

  @override
  State<TaskAiSuggestBottomSheet> createState() =>
      _TaskAiSuggestBottomSheetState();
}

class _TaskAiSuggestBottomSheetState extends State<TaskAiSuggestBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        controller: widget.controller,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withAlpha(50),
                border: Border.all(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.auto_awesome_outlined, color: primaryColor),
                      Text('Transcription', style: textTheme.bodyMedium),
                    ],
                  ),
                  Text(widget.text, style: textTheme.bodyMedium),
                ],
              ),
            ),
            SizedBox(height: 16),
            Consumer<AiProvider>(
              builder: (context, value, child) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.analyzeNotes.length,
                  itemBuilder: (context, index) {
                    return AiTaskItem(value.analyzeNotes[index]);
                  },
                );
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Create Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
