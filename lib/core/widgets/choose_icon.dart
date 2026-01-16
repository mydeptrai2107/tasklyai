import 'package:flutter/material.dart';

class ChooseIcon extends StatefulWidget {
  const ChooseIcon({
    super.key,
    required this.selectedColor,
    required this.onChange,
  });

  final Color selectedColor;
  final Function(IconData value) onChange;

  @override
  State<ChooseIcon> createState() => _ChooseIconState();
}

class _ChooseIconState extends State<ChooseIcon> {
  final List<IconData> icons = [
    Icons.work,
    Icons.lightbulb,
    Icons.folder,
    Icons.flag,
    Icons.home,
    Icons.star,
    Icons.palette,
    Icons.school,
    Icons.shopping_bag,
    Icons.music_note,
    Icons.build,
    Icons.search,
  ];

  IconData selectedIcon = Icons.work;

  @override
  Widget build(BuildContext context) {
    final selectedColor = widget.selectedColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose icon',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: icons.map((icon) {
              final isSelected = icon == selectedIcon;
              return GestureDetector(
                onTap: () {
                  setState(() => selectedIcon = icon);
                  widget.onChange.call(selectedIcon);
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor.withAlpha(40)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? selectedColor : Colors.grey.shade300,
                    ),
                  ),
                  child: Icon(icon, color: selectedColor),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
