import 'package:flutter/material.dart';
import 'package:tasklyai/models/checklist_item.dart';
import 'package:tasklyai/presentation/notes/widgets/add_checklist_widget.dart';

class AddSubtask extends StatelessWidget {
  const AddSubtask({super.key, required this.onChange});

  final ValueChanged<List<ChecklistItem>> onChange;

  @override
  Widget build(BuildContext context) {
    return AddCheckListWidget(
      title: 'Subtask',
      onChanged: onChange,
    );
  }
}
