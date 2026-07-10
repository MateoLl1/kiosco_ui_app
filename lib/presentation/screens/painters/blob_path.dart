import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dibuja una mancha orgánica (blob) variando el radio alrededor del centro
/// en vez de un círculo perfecto, para una silueta más abstracta.
Path buildBlobPath(Offset center, double r, List<double> radios) {
  final path = Path();
  final n = radios.length;

  Offset puntoEn(int i) {
    final angulo = (i / n) * 2 * math.pi;
    final radio = r * radios[i % n];
    return center + Offset(math.cos(angulo), math.sin(angulo)) * radio;
  }

  path.moveTo(puntoEn(0).dx, puntoEn(0).dy);
  for (int i = 1; i <= n; i++) {
    final anguloPrev = ((i - 1) / n) * 2 * math.pi;
    final anguloAct = (i / n) * 2 * math.pi;
    final anguloControl = (anguloPrev + anguloAct) / 2;
    final radioControl =
        r * ((radios[(i - 1) % n] + radios[i % n]) / 2) * 1.18;
    final control = center +
        Offset(math.cos(anguloControl), math.sin(anguloControl)) * radioControl;
    final punto = puntoEn(i);
    path.quadraticBezierTo(control.dx, control.dy, punto.dx, punto.dy);
  }
  path.close();
  return path;
}
