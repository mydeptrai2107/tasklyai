import 'package:flutter/material.dart';
import 'package:tasklyai/core/widgets/icon_int.dart';
import 'package:tasklyai/models/area_model.dart';

class AreaCard extends StatelessWidget {
  final AreaModel area;
  final VoidCallback? onTap;

  const AreaCard({super.key, required this.area, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [_buildHeader(), const SizedBox(height: 12), _buildStats()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(area.color).withAlpha(40),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconInt(icon: area.icon, color: area.color),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                area.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                area.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _StatDot(color: Colors.blue, text: '${area.folderCount} folders'),
        const SizedBox(width: 12),
        _StatDot(color: Colors.orange, text: '${area.projectCount} projects'),
        const SizedBox(width: 12),
        _StatDot(color: Colors.green, text: '${area.noteCount} notes'),
        const Spacer(),
        _TaskChip(count: area.projectCount, color: Color(area.color)),
      ],
    );
  }
}

class _StatDot extends StatelessWidget {
  final Color color;
  final String text;

  const _StatDot({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _TaskChip extends StatelessWidget {
  final int count;
  final Color color;

  const _TaskChip({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count tasks',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
