import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/configs/dialog_service.dart';
import 'package:tasklyai/core/enum/task_status.dart';
import 'package:tasklyai/core/widgets/project_dropdown.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/notes/provider/note_provider.dart';

Future<void> showConvertToTaskDialog(
  BuildContext context,
  String? folderId,
  CardModel item,
) async {
  DateTime? dueDate;
  TaskStatus status = TaskStatus.notStarted;
  String? projectId;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            title: const Text('Convert to task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogRow(
                  label: 'Due date',
                  child: TextButton.icon(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: dialogContext,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate == null) return;
                      setState(() {
                        dueDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                        );
                      });
                    },
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text(
                      dueDate == null ? 'Pick date' : _formatDate(dueDate!),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _DialogRow(
                  label: 'Status',
                  child: DropdownButton<TaskStatus>(
                    value: status,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => status = value);
                    },
                    items: TaskStatus.values
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.label)),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                ProjectDropdown(
                  placeholder: 'No project',
                  onChanged: (project) {
                    setState(() => projectId = project?.id);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (dueDate == null) {
                    DialogService.error(
                      dialogContext,
                      message: 'Vui long chon due date',
                    );
                    return;
                  }
                  final updated = await context
                      .read<NoteProvider>()
                      .convertToTask(
                        context: dialogContext,
                        cardId: item.id,
                        dueDate: dueDate!,
                        projectId: projectId,
                        status: status.eng,
                        dateOnly: true,
                      );
                  if (updated == null) return;
                  if (!context.mounted) return;
                  Navigator.pop(dialogContext);
                  if (folderId != null) {
                    context.read<NoteProvider>().fetchNote(folderId);
                  }
                  if (Navigator.of(context).canPop()) {
                    Navigator.pop(context, true);
                  } else {
                    setState(() => item = updated);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Converted to task')),
                    );
                  }
                },
                child: const Text('Convert'),
              ),
            ],
          );
        },
      );
    },
  );
}

String _formatDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

class _DialogRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _DialogRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3F7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ],
    );
  }
}
