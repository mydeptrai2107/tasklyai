import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/ai_task_model.dart';
import 'package:tasklyai/presentation/task_project/provider/ai_provider.dart';

class AiTaskItem extends StatefulWidget {
  const AiTaskItem(this.item, {super.key});

  final AiTaskModel item;

  @override
  State<AiTaskItem> createState() => _AiTaskItemState();
}

class _AiTaskItemState extends State<AiTaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(right: 16, bottom: 16, top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: primaryColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: widget.item.isSlected,
            onChanged: (value) {
              widget.item.isSlected = value!;
              // context.read<AiProvider>().changeTaskAvtive();
              setState(() {});
            },
          ),
          Expanded(
            child: Column(
              spacing: 8,
              children: [
                Text(widget.item.taskText),
                Row(
                  spacing: 8,
                  children: [
                    _tag(
                      widget.item.priority.label,
                      widget.item.priority.color,
                    ),
                    _time(
                      widget.item.estimatedTimeMinutes.toString(),
                      Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _time(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.grey, size: 16),
          Text("$text min", style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
