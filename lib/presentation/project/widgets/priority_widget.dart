import 'package:flutter/material.dart';
import 'package:tasklyai/core/configs/extention.dart';
import 'package:tasklyai/core/enum/priority_enum.dart';
import 'package:tasklyai/core/theme/color_app.dart';

class PriorityWidget extends StatefulWidget {
  const PriorityWidget({
    super.key,
    required this.selected,
    required this.ontap,
  });

  final Priority? selected;
  final Function(Priority value) ontap;

  @override
  State<PriorityWidget> createState() => _PriorityWidgetState();
}

class _PriorityWidgetState extends State<PriorityWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: Priority.values
          .map(
            (e) => Expanded(
              child: _buildItem(context, e, widget.selected, widget.ontap),
            ),
          )
          .toList(),
    );
  }

  Widget _buildItem(
    BuildContext context,
    Priority priority,
    Priority? selected,
    Function(Priority value) ontap,
  ) {
    final textTheme = context.theme.textTheme;

    return GestureDetector(
      onTap: () {
        ontap.call(priority);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected == priority ? primaryColor.withAlpha(20) : null,
          border: Border.all(
            width: 1.5,
            color: priority == selected ? primaryColor : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 6,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: priority.color,
                shape: BoxShape.circle,
              ),
            ),
            Text(priority.label, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
