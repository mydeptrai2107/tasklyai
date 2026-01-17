import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/enum/task_status.dart';
import 'package:tasklyai/models/area_model.dart';
import 'package:tasklyai/models/card_model.dart';
import 'package:tasklyai/presentation/area/area_detail_screen.dart';
import 'package:tasklyai/presentation/area/provider/area_provider.dart';

class CardCalenderWidget extends StatelessWidget {
  const CardCalenderWidget(this.task, {super.key});

  final CardModel task;

  @override
  Widget build(BuildContext context) {
    final areas = context.watch<AreaProvider>().areas;

    AreaModel? result;
    for (final e in areas) {
      if (e.id == task.area?.id) {
        result = e;
        break;
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (result != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AreaDetailScreen(result!);
              },
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(left: BorderSide(color: task.status.color, width: 4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🎯 Status icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: task.status.color.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _statusIcon(task.status),
                size: 18,
                color: task.status.color,
              ),
            ),

            const SizedBox(width: 12),

            /// 📄 Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 📝 Title
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: task.status == TaskStatus.completed
                          ? Colors.grey
                          : Colors.black87,
                      decoration: task.status == TaskStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// 🏷 Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: task.status.color.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: task.status.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            /// ➡ Arrow
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

IconData _statusIcon(TaskStatus status) {
  switch (status) {
    case TaskStatus.notStarted:
      return Icons.radio_button_unchecked;
    case TaskStatus.inProgress:
      return Icons.play_circle_outline;
    case TaskStatus.paused:
      return Icons.pause_circle_outline;
    case TaskStatus.completed:
      return Icons.check_circle_outline;
  }
}
