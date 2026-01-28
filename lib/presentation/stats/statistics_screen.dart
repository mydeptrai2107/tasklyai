import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/models/statistics_range_model.dart';
import 'package:tasklyai/presentation/stats/provider/stats_provider.dart';
import 'package:tasklyai/presentation/stats/widgets/daily_activity_chart.dart';
import 'package:tasklyai/presentation/stats/widgets/statistics_appbar.dart';

class StatisticsRangeScreen extends StatefulWidget {
  const StatisticsRangeScreen({super.key});

  @override
  State<StatisticsRangeScreen> createState() => _StatisticsRangeScreenState();
}

class _StatisticsRangeScreenState extends State<StatisticsRangeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<StatisticsProvider>().changeRange(StatsRangeType.week);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: const StatisticsAppBar(),
      ),
      body: Consumer<StatisticsProvider>(
        builder: (_, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator()),

                if (provider.data != null) ...[
                  _summaryGrid(provider.data!.summary),
                  const SizedBox(height: 24),
                  DailyActivityChart(provider.data!.daily),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _summaryGrid(RangeSummary s) {
  return GridView(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.4,
    ),
    children: [
      _summaryCard(
        title: 'Tasks Created',
        value: s.totalCreated,
        icon: Icons.add_task,
        color: primaryColor,
      ),
      _summaryCard(
        title: 'Tasks Completed',
        value: s.totalCompleted,
        icon: Icons.check_circle,
        color: completedColor,
      ),
      _summaryCard(
        title: 'Overdue Tasks',
        value: s.overdueCount,
        icon: Icons.warning_amber_rounded,
        color: overdueColor,
      ),
      _summaryCard(
        title: 'Completion Rate',
        value: '${s.completionRate}%',
        icon: Icons.trending_up,
        color: Colors.orange,
      ),
    ],
  );
}

Widget _summaryCard({
  required String title,
  required dynamic value,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          spacing: 10,
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha(30),
              child: Icon(icon, color: color),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    ),
  );
}
