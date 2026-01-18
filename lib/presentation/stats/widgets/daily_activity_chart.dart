import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/statistics_range_model.dart';

class DailyActivityChart extends StatelessWidget {
  final List<DailyStat> data;

  const DailyActivityChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Task Activity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Created vs Completed tasks per day',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          /// LEGEND
          Row(
            children: [
              _legend(primaryColor, 'Created'),
              const SizedBox(width: 16),
              _legend(completedColor, 'Completed'),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(height: 260, child: LineChart(_chartData())),
        ],
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  LineChartData _chartData() {
    return LineChartData(
      gridData: FlGridData(show: true, horizontalInterval: 5),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 32),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              final i = value.toInt();
              if (i < 0 || i >= data.length) return const SizedBox();
              return Text(
                data[i].dayOfWeek,
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      lineBarsData: [
        _line(primaryColor, data.map((e) => e.created).toList()),
        _line(completedColor, data.map((e) => e.completed).toList()),
      ],
    );
  }

  LineChartBarData _line(Color color, List<int> values) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      barWidth: 3,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
      spots: values
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList(),
    );
  }
}
