import 'package:tasklyai/core/network/dio_client.dart';
import 'package:tasklyai/models/statistics_range_model.dart';

class StatisticsRepository {
  final DioClient _dio = DioClient();

  Future<StatisticsResponse> getStatsRange(DateTime start, DateTime end) async {
    final res = await _dio.get(
      '/stats/range',
      params: {'startDate': _format(start), 'endDate': _format(end)},
    );

    return StatisticsResponse.fromJson(res.data);
  }

  String _format(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
