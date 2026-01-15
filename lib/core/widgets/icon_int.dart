import 'package:flutter/material.dart';

class IconInt extends StatelessWidget {
  const IconInt({
    super.key,
    required this.icon,
    required this.color,
    this.size,
  });

  final int icon;
  final int color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(icon, fontFamily: 'MaterialIcons'),
      color: Color(color),
      size: size,
    );
  }
}
