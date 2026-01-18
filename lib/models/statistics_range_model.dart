class StatisticsResponse {
  final RangeSummary summary;
  final List<DailyStat> daily;

  StatisticsResponse({required this.summary, required this.daily});

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'];
    return StatisticsResponse(
      summary: RangeSummary.fromJson(stats['summary']),
      daily: (stats['dailyBreakdown'] as List)
          .map((e) => DailyStat.fromJson(e))
          .toList(),
    );
  }
}

class RangeSummary {
  final int totalCreated;
  final int totalCompleted;
  final int totalTasks;
  final int totalNotes;
  final int overdueCount;
  final double completionRate;

  RangeSummary({
    required this.totalCreated,
    required this.totalCompleted,
    required this.totalTasks,
    required this.totalNotes,
    required this.overdueCount,
    required this.completionRate,
  });

  factory RangeSummary.fromJson(Map<String, dynamic> json) {
    return RangeSummary(
      totalCreated: json['totalCreated'],
      totalCompleted: json['totalCompleted'],
      totalTasks: json['totalTasks'],
      totalNotes: json['totalNotes'],
      overdueCount: json['overdueCount'],
      completionRate: double.parse((json['completionRate'] ?? 0).toString()),
    );
  }
}

class DailyStat {
  final String date;
  final String dayOfWeek;
  final int created;
  final int completed;

  DailyStat({
    required this.date,
    required this.dayOfWeek,
    required this.created,
    required this.completed,
  });

  factory DailyStat.fromJson(Map<String, dynamic> json) {
    return DailyStat(
      date: json['date'],
      dayOfWeek: json['dayOfWeek'],
      created: json['created'],
      completed: json['completed'],
    );
  }
}
