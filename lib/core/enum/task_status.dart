import 'package:flutter/material.dart';

enum TaskStatus {
  notStarted('Chưa bắt đầu', 'todo', Color(0xFF9E9E9E)),
  inProgress('Đang làm', 'doing', Color(0xFF2196F3)),
  completed('Hoàn thành', 'done', Color(0xFF4CAF50)),
  paused('Tạm dừng', 'pending', Color(0xFFFF9800));

  final String label;
  final String eng;
  final Color color;

  const TaskStatus(this.label, this.eng, this.color);

  /// Convert từ String sang enum
  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.eng.toLowerCase() == value.toLowerCase(),
      orElse: () => TaskStatus.notStarted,
    );
  }
}
