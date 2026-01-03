import 'package:flutter/material.dart';

enum Priority {
  low('Thấp', 'Low', Color(0xFF4CAF50)),
  medium('Trung bình', 'Medium', Color(0xFFFFC107)),
  high('Cao', 'High', Color(0xFFFF9800)),
  urgent('Khẩn cấp', 'Urgent', Color(0xFFF44336));

  final String label;
  final String eng;
  final Color color;

  const Priority(this.label, this.eng, this.color);

  /// Convert từ String sang enum
  static Priority fromString(String value) {
    return Priority.values.firstWhere(
      (e) =>
          e.label.toLowerCase() == value.toLowerCase() ||
          e.eng.toLowerCase() == value.toLowerCase(),
      orElse: () => Priority.low,
    );
  }
}
