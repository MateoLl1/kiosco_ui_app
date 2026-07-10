import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/brand_colors.dart';

class Home2Painter extends CustomPainter {
  final Color primaryColor;

  Home2Painter({super.repaint, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
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

    // Anillo sólido gris flotando sobre la cuña.
    canvas.drawCircle(
      Offset(size.width * 0.34, size.height * 0.10),
      size.width * 0.045,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = chevroletGray,
    );

    // Cuña pequeña sólida gris, debajo de la principal.
    final pathTop2 = Path()
      ..moveTo(0, topH)
      ..lineTo(size.width * 0.22, topH)
      ..quadraticBezierTo(
        size.width * 0.08,
        topH + size.height * 0.05,
        0,
        topH + size.height * 0.12,
      )
      ..close();
    canvas.drawPath(
      pathTop2,
      Paint()..color = chevroletGray.withValues(alpha: 0.16),
    );

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

    // Punto sólido azul, esquina superior derecha.
    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.16),
      size.width * 0.03,
      Paint()..color = primaryColor,
    );

    // Anillo sólido azul, más abajo a la derecha.
    canvas.drawCircle(
      Offset(size.width * 0.90, size.height * 0.42),
      size.width * 0.04,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = primaryColor,
    );

    // Barra sólida gris, al centro derecha.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.84,
          size.height * 0.58,
          size.width * 0.09,
          size.width * 0.022,
        ),
        Radius.circular(size.width * 0.02),
      ),
      Paint()..color = chevroletGray,
    );

    // Punto sólido azul, pequeño detalle al centro.
    canvas.drawCircle(
      Offset(size.width * 0.60, size.height * 0.62),
      size.width * 0.016,
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
