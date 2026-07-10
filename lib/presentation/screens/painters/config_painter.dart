import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/brand_colors.dart';

class ConfigBackgroundPainter extends CustomPainter {
  final Color colorFondo;
  final Color colorCirculoSuperior;
  final Color colorCirculoInferior;

  ConfigBackgroundPainter({
    required this.colorFondo,
    required this.colorCirculoSuperior,
    required this.colorCirculoInferior,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = colorFondo
        ..style = PaintingStyle.fill,
    );

    // Panel sólido azul, arriba a la izquierda.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          -size.width * 0.12,
          -size.height * 0.08,
          size.width * 0.42,
          size.height * 0.30,
        ),
        bottomRight: Radius.circular(size.width * 0.26),
      ),
      Paint()..color = colorCirculoSuperior.withValues(alpha: 0.16),
    );

    canvas.drawCircle(
      Offset(size.width * 0.30, size.height * 0.08),
      size.width * 0.03,
      Paint()..color = colorCirculoSuperior,
    );

    // Panel sólido gris, arriba a la derecha, más pequeño.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.82,
          -size.height * 0.05,
          size.width * 0.22,
          size.height * 0.16,
        ),
        bottomLeft: Radius.circular(size.width * 0.12),
      ),
      Paint()..color = chevroletGray.withValues(alpha: 0.20),
    );

    // Panel sólido gris, abajo a la derecha.
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.72,
          size.height * 0.78,
          size.width * 0.40,
          size.height * 0.30,
        ),
        topLeft: Radius.circular(size.width * 0.26),
      ),
      Paint()..color = chevroletGray.withValues(alpha: 0.18),
    );

    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.64),
      size.width * 0.022,
      Paint()..color = colorCirculoInferior,
    );

    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.60),
      size.width * 0.045,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = chevroletGray,
    );

    // Barra sólida azul, abajo a la izquierda.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.88,
          size.width * 0.09,
          size.width * 0.02,
        ),
        Radius.circular(size.width * 0.015),
      ),
      Paint()..color = colorCirculoInferior,
    );

    // Punto sólido gris, al centro.
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.30),
      size.width * 0.014,
      Paint()..color = chevroletGray,
    );
  }

  @override
  bool shouldRepaint(covariant ConfigBackgroundPainter oldDelegate) {
    return oldDelegate.colorFondo != colorFondo ||
        oldDelegate.colorCirculoSuperior != colorCirculoSuperior ||
        oldDelegate.colorCirculoInferior != colorCirculoInferior;
  }
}
