import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/brand_colors.dart';

class Home3Painter extends CustomPainter {
  final Color primaryColor;

  Home3Painter({
    super.repaint,
    required this.primaryColor,
  });

  Path _triangulo(Offset p1, Offset p2, Offset p3) {
    return Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // --- Grupo 1: esquina superior izquierda ---
    canvas.drawPath(
      _triangulo(
        Offset(0, 0),
        Offset(size.width * 0.30, 0),
        Offset(0, size.height * 0.24),
      ),
      Paint()..color = primaryColor.withValues(alpha: 0.16),
    );

    canvas.drawPath(
      _triangulo(
        Offset(size.width * 0.06, size.height * 0.02),
        Offset(size.width * 0.16, size.height * 0.09),
        Offset(size.width * 0.02, size.height * 0.14),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = chevroletGray,
    );

    // --- Grupo 2: esquina superior derecha ---
    canvas.drawPath(
      _triangulo(
        Offset(size.width, 0),
        Offset(size.width * 0.72, 0),
        Offset(size.width, size.height * 0.20),
      ),
      Paint()..color = chevroletGray.withValues(alpha: 0.18),
    );

    canvas.drawCircle(
      Offset(size.width * 0.86, size.height * 0.10),
      size.width * 0.018,
      Paint()..color = primaryColor,
    );

    // --- Grupo 3: esquina inferior derecha ---
    canvas.drawPath(
      _triangulo(
        Offset(size.width, size.height),
        Offset(size.width * 0.66, size.height),
        Offset(size.width, size.height * 0.74),
      ),
      Paint()..color = primaryColor.withValues(alpha: 0.16),
    );

    canvas.drawPath(
      _triangulo(
        Offset(size.width * 0.92, size.height * 0.90),
        Offset(size.width * 0.82, size.height * 0.84),
        Offset(size.width * 0.96, size.height * 0.78),
      ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = chevroletGray,
    );

    // --- Grupo 4: esquina inferior izquierda ---
    canvas.drawPath(
      _triangulo(
        Offset(0, size.height),
        Offset(size.width * 0.24, size.height),
        Offset(0, size.height * 0.78),
      ),
      Paint()..color = chevroletGray.withValues(alpha: 0.16),
    );

    canvas.drawCircle(
      Offset(size.width * 0.10, size.height * 0.90),
      size.width * 0.016,
      Paint()..color = primaryColor,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.02,
          size.height * 0.68,
          size.width * 0.08,
          size.width * 0.018,
        ),
        Radius.circular(size.width * 0.012),
      ),
      Paint()..color = primaryColor,
    );
  }

  @override
  bool shouldRepaint(covariant Home3Painter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }

  @override
  bool shouldRebuildSemantics(covariant Home3Painter oldDelegate) => false;
}
