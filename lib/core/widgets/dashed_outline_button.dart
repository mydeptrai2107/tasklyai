import 'package:flutter/material.dart';

class DashedOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double borderRadius;
  final Color? color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final EdgeInsets padding;

  const DashedOutlineButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 12,
    this.color = Colors.deepPurple,
    this.strokeWidth = 1.5,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: color!,
          strokeWidth: strokeWidth,
          radius: borderRadius,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
        ),
        child: Padding(
          padding: padding,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics().first;
    double distance = 0.0;

    while (distance < metrics.length) {
      final double next = distance + dashWidth;
      canvas.drawPath(metrics.extractPath(distance, next), paint);
      distance = next + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
