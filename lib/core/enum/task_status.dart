import 'package:flutter/material.dart';

enum TaskStatus {
  notStarted('Chưa bắt đầu', Color(0xFF9E9E9E)),
  inProgress('Đang làm', Color(0xFF2196F3)),
  completed('Hoàn thành', Color(0xFF4CAF50)),
  paused('Tạm dừng', Color(0xFFFF9800));

  final String label;
  final Color color;

  const TaskStatus(this.label, this.color);

  /// Convert từ String sang enum
  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => TaskStatus.notStarted,
    );
  }
}
