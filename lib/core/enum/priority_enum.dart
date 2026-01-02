import 'package:flutter/material.dart';

enum Priority {
  low('Thấp', Color(0xFF4CAF50)),
  medium('Trung bình', Color(0xFFFFC107)),
  high('Cao', Color(0xFFFF9800)),
  urgent('Khẩn cấp', Color(0xFFF44336));

  final String label;
  final Color color;

  const Priority(this.label, this.color);

  /// Convert từ String sang enum
  static Priority fromString(String value) {
    return Priority.values.firstWhere(
      (e) => e.label.toLowerCase() == value.toLowerCase(),
      orElse: () => Priority.low,
    );
  }
}
