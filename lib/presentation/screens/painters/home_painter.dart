import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/brand_colors.dart';

class HomePainter extends CustomPainter {
  final Color primaryColor;

  HomePainter({
    super.repaint,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Panel sólido azul, arriba a la izquierda.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          -size.width * 0.14,
          -size.height * 0.10,
          size.width * 0.46,
          size.height * 0.34,
        ),
        bottomRight: Radius.circular(size.width * 0.30),
      ),
      Paint()..color = primaryColor.withValues(alpha: 0.16),
    );

    // Panel sólido gris, abajo a la derecha.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.70,
          size.height * 0.76,
          size.width * 0.44,
          size.height * 0.34,
        ),
        topLeft: Radius.circular(size.width * 0.30),
      ),
      Paint()..color = chevroletGray.withValues(alpha: 0.18),
    );

    // Panel sólido azul, más chico, arriba a la derecha.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.80,
          -size.height * 0.06,
          size.width * 0.26,
          size.height * 0.18,
        ),
        bottomLeft: Radius.circular(size.width * 0.14),
      ),
      Paint()..color = primaryColor.withValues(alpha: 0.14),
    );

    // Anillo sólido gris, arriba a la derecha.
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.16),
      size.width * 0.05,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = chevroletGray,
    );

    // Anillo sólido azul, abajo a la izquierda.
    canvas.drawCircle(
      Offset(size.width * 0.10, size.height * 0.86),
      size.width * 0.035,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = primaryColor,
    );

    // Barra sólida azul, abajo a la izquierda.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.10,
          size.height * 0.72,
          size.width * 0.10,
          size.width * 0.025,
        ),
        Radius.circular(size.width * 0.02),
      ),
      Paint()..color = primaryColor,
    );

    // Barra sólida gris, al centro.
    

    // Punto sólido azul, al centro.
    canvas.drawCircle(
      Offset(size.width * 0.58, size.height * 0.46),
      size.width * 0.018,
      Paint()..color = primaryColor,
    );

    // Punto sólido gris, a la izquierda.
    canvas.drawCircle(
      Offset(size.width * 0.24, size.height * 0.40),
      size.width * 0.014,
      Paint()..color = chevroletGray,
    );

    // Cuadro sólido azul, rotado, pequeño detalle.
    canvas.save();
    canvas.translate(size.width * 0.70, size.height * 0.42);
    canvas.rotate(0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: size.width * 0.045,
          height: size.width * 0.045,
        ),
        Radius.circular(size.width * 0.008),
      ),
      Paint()..color = chevroletGray.withValues(alpha: 0.85),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HomePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }

  @override
  bool shouldRebuildSemantics(covariant HomePainter oldDelegate) => false;
}
