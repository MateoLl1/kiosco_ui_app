import 'package:flutter/material.dart';

class HomePainter extends CustomPainter {
  final Color primaryColor;

  HomePainter({
    super.repaint,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    fillPaint.color = primaryColor.withValues(alpha: 0.08);
    canvas.drawCircle(
      Offset(size.width * 0.12, size.height * 0.18),
      size.width * 0.18,
      fillPaint,
    );

    
    fillPaint.color = primaryColor.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.20),
      size.width * 0.22,
      fillPaint,
    );

    fillPaint.color = primaryColor.withValues(alpha: 0.05);
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.82),
      size.width * 0.28,
      fillPaint,
    );

    fillPaint.color = primaryColor.withValues(alpha: 0.04);
    canvas.drawCircle(
      Offset(size.width * 0.20, size.height * 0.78),
      size.width * 0.14,
      fillPaint,
    );

    strokePaint.color = primaryColor.withValues(alpha: 0.14);
    canvas.drawCircle(
      Offset(size.width * 0.52, size.height * 0.14),
      size.width * 0.08,
      strokePaint,
    );

    strokePaint.color = primaryColor.withValues(alpha: 0.12);
    canvas.drawCircle(
      Offset(size.width * 0.30, size.height * 0.55),
      size.width * 0.10,
      strokePaint,
    );

    strokePaint.color = primaryColor.withValues(alpha: 0.10);
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.48),
      size.width * 0.12,
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant HomePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }

  @override
  bool shouldRebuildSemantics(covariant HomePainter oldDelegate) => false;
}