import 'package:flutter/material.dart';
import 'package:tasklyai/models/statistics_range_model.dart';
import 'package:tasklyai/repository/statistcs_repository.dart';

enum StatsRangeType { week, month, year, custom }

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repo = StatisticsRepository();

  bool isLoading = false;
  StatsRangeType rangeType = StatsRangeType.week;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  StatisticsResponse? data;

  /// ========== PUBLIC API ==========
  Future<void> changeRange(StatsRangeType type) async {
    rangeType = type;

    final now = DateTime.now();

    switch (type) {
      case StatsRangeType.week:
        startDate = _startOfWeek(now);
        endDate = _endOfWeek(now);
        break;

      case StatsRangeType.month:
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;

      case StatsRangeType.year:
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;

      case StatsRangeType.custom:
        return;
    }

    await fetchRange(startDate, endDate);
  }

  Future<void> fetchCustomRange(DateTime start, DateTime end) async {
    rangeType = StatsRangeType.custom;
    startDate = start;
    endDate = end;
    await fetchRange(start, end);
  }

  /// ========== CORE ==========
  Future<void> fetchRange(DateTime start, DateTime end) async {
    isLoading = true;
    notifyListeners();

    try {
      data = await _repo.getStatsRange(start, end);
    } catch (e) {
      debugPrint('Stats error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  /// ========== UI HELPERS ==========
  String get rangeLabel {
    switch (rangeType) {
      case StatsRangeType.week:
        return 'This week';
      case StatsRangeType.month:
        return 'This month';
      case StatsRangeType.year:
        return 'This year';
      case StatsRangeType.custom:
        return '${_fmt(startDate)} - ${_fmt(endDate)}';
    }
  }

  DateTimeRange get currentRange =>
      DateTimeRange(start: startDate, end: endDate);

  /// ========== UTILS ==========
  DateTime _startOfWeek(DateTime d) =>
      d.subtract(Duration(days: d.weekday - 1));

  DateTime _endOfWeek(DateTime d) => d.add(Duration(days: 7 - d.weekday));

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}
