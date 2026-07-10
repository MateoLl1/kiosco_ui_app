import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/brand_colors.dart';

class Home2Painter extends CustomPainter {
  final Color primaryColor;

  Home2Painter({super.repaint, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    // --- Grupo 1: cuña superior izquierda, con sus propios acentos ---
    final topH = size.height * 0.26;
    final leftW = size.width * 0.46;

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

    canvas.drawPath(
      pathTop,
      Paint()..color = primaryColor.withValues(alpha: 0.18),
    );

    // Anillo gris, apoyado sobre el borde de la cuña.
    canvas.drawCircle(
      Offset(size.width * 0.34, size.height * 0.10),
      size.width * 0.045,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = chevroletGray,
    );

    // Punto azul, justo debajo del anillo, mismo grupo.
    canvas.drawCircle(
      Offset(size.width * 0.30, size.height * 0.20),
      size.width * 0.016,
      Paint()..color = primaryColor,
    );

    // Barra gris corta, saliendo de la punta de la cuña.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.02,
          topH + size.height * 0.03,
          size.width * 0.09,
          size.width * 0.02,
        ),
        Radius.circular(size.width * 0.015),
      ),
      Paint()..color = chevroletGray,
    );

    // --- Grupo 2: ola inferior derecha, con sus propios acentos ---
    final bottomStartY = size.height * 0.80;

    final pathBottom = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, bottomStartY)
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.72,
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

    canvas.drawPath(
      pathBottom,
      Paint()..color = chevroletGray.withValues(alpha: 0.16),
    );

    // Anillo azul, apoyado sobre el borde de la ola.
    canvas.drawCircle(
      Offset(size.width * 0.66, size.height * 0.78),
      size.width * 0.045,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = primaryColor,
    );

    // Punto gris, junto al anillo, mismo grupo.
    canvas.drawCircle(
      Offset(size.width * 0.78, size.height * 0.86),
      size.width * 0.016,
      Paint()..color = chevroletGray,
    );

    // Barra azul corta, sobre el extremo derecho de la ola.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.88,
          size.height * 0.68,
          size.width * 0.09,
          size.width * 0.02,
        ),
        Radius.circular(size.width * 0.015),
      ),
      Paint()..color = primaryColor,
    );
  }

  @override
  bool shouldRepaint(covariant Home2Painter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }

  @override
  bool shouldRebuildSemantics(covariant Home2Painter oldDelegate) => false;
}
