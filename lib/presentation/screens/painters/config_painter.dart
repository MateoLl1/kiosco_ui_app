import 'package:flutter/material.dart';

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
    final fondo = Paint()
      ..color = colorFondo
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, fondo);

    final circuloSuperior = Paint()
      ..color = colorCirculoSuperior
      ..style = PaintingStyle.fill;

    final circuloInferior = Paint()
      ..color = colorCirculoInferior
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.12),
      size.width * 0.18,
      circuloSuperior,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.88),
      size.width * 0.25,
      circuloInferior,
    );
  }

  @override
  bool shouldRepaint(covariant ConfigBackgroundPainter oldDelegate) {
    return oldDelegate.colorFondo != colorFondo ||
        oldDelegate.colorCirculoSuperior != colorCirculoSuperior ||
        oldDelegate.colorCirculoInferior != colorCirculoInferior;
  }
}