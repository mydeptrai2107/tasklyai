import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasklyai/core/theme/color_app.dart';
import 'package:tasklyai/presentation/stats/provider/stats_provider.dart';

class StatisticsAppBar extends StatelessWidget {
  const StatisticsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsProvider>(
      builder: (_, provider, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withAlpha(110)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(provider),
              const SizedBox(height: 16),
              _RangeSelector(provider),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final StatisticsProvider provider;

  const _Header(this.provider);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(color: Colors.white),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              provider.rangeLabel,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withAlpha(110),
              ),
            ),
          ],
        ),
        const Spacer(),
        _CalendarButton(provider),
      ],
    );
  }
}

class _CalendarButton extends StatelessWidget {
  final StatisticsProvider provider;

  const _CalendarButton(this.provider);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: provider.currentRange,
        );

        if (range != null) {
          provider.fetchCustomRange(range.start, range.end);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(35),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.calendar_month_rounded, color: Colors.white),
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  final StatisticsProvider provider;

  const _RangeSelector(this.provider);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RangeChip(
          label: 'Week',
          selected: provider.rangeType == StatsRangeType.week,
          onTap: () => provider.changeRange(StatsRangeType.week),
        ),
        const SizedBox(width: 10),
        _RangeChip(
          label: 'Month',
          selected: provider.rangeType == StatsRangeType.month,
          onTap: () => provider.changeRange(StatsRangeType.month),
        ),
        const SizedBox(width: 10),
        _RangeChip(
          label: 'Year',
          selected: provider.rangeType == StatsRangeType.year,
          onTap: () => provider.changeRange(StatsRangeType.year),
        ),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white.withAlpha(35),
            borderRadius: BorderRadius.circular(20),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? primaryColor : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
