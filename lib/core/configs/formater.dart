import 'package:intl/intl.dart';

class Formatter {
  Formatter._();

  /// dd/MM/yyyy
  static String date(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// HH:mm
  static String time(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// dd/MM/yyyy HH:mm
  static String dateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// yyyy-MM-dd (API)
  static String apiDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// yyyy-MM-dd HH:mm:ss (API)
  static String apiDateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  /// Thứ + ngày (VN)
  static String weekdayDate(DateTime date) {
    return DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(date);
  }

  /// Ví dụ: 5 phút trước, 2 giờ trước
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) {
      return 'Vừa xong';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else {
      return dateTime(date);
    }
  }

  /// Khoảng thời gian (9:15 - 10:45)
  static String timeRange(DateTime start, DateTime end) {
    return '${time(start)} - ${time(end)}';
  }

  /// Tổng thời gian (1 giờ 20 phút)
  static String duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours giờ $minutes phút';
    }
    return '$minutes phút';
  }

  static String dateJson(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}'
        '-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';
  }
}
