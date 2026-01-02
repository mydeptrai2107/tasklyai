import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor() {
    var hex = replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

extension BuildContextExt on BuildContext {
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  Size get media {
    return MediaQuery.sizeOf(this);
  }

  ThemeData get theme {
    return Theme.of(this);
  }
}

extension ColorHexX on Color {
  String toHex({bool withAlpha = false}) {
    int c(double v) => (v * 255).round().clamp(0, 255);

    final a = c(this.a);
    final r = c(this.r);
    final g = c(this.g);
    final b = c(this.b);

    final hex = withAlpha
        ? '${a.toRadixString(16)}'
              '${r.toRadixString(16)}'
              '${g.toRadixString(16)}'
              '${b.toRadixString(16)}'
        : '${r.toRadixString(16)}'
              '${g.toRadixString(16)}'
              '${b.toRadixString(16)}';

    return '#${hex.padLeft(withAlpha ? 8 : 6, '0').toUpperCase()}';
  }
}

extension PercentFormatter on double {
  String toPercent() {
    final value = toStringAsFixed(2);
    final trimmed = value.endsWith('.00')
        ? value.substring(0, value.length - 3)
        : value
              .replaceFirst(RegExp(r'0+$'), '')
              .replaceFirst(RegExp(r'\.$'), '');
    return '$trimmed%';
  }
}
