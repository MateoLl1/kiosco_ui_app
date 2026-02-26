import 'package:flutter/material.dart';

class Home2Painter extends CustomPainter {
  final Color primaryColor;

  Home2Painter({super.repaint, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = primaryColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    final topH = size.height * 0.22;
    final leftW = size.width * 0.42;

    final pathTop = Path()
      ..moveTo(0, 0)
      ..lineTo(leftW, 0)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.06,
        0,
        topH,
      )
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(pathTop, paint1);

    final bottomStartY = size.height * 0.82;

    final pathBottom = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, bottomStartY)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.74,
        size.width * 0.50,
        bottomStartY,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.90,
        size.width,
        size.height * 0.80,
      )
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(pathBottom, paint2);
  }

  @override
  bool shouldRepaint(covariant Home2Painter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }

  @override
  bool shouldRebuildSemantics(covariant Home2Painter oldDelegate) => false;
}