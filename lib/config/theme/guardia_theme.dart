import 'package:flutter/material.dart';

class GuardiaTheme extends ThemeExtension<GuardiaTheme> {
  final Color mantenimiento;
  final Color reparacion;
  final Color noLlego;
  final Color bordeDefault;

  const GuardiaTheme({
    this.mantenimiento = const Color(0xFF8080FF),
    this.reparacion = const Color(0xFFFFC080),
    this.noLlego = const Color(0xFF8B0000),
    this.bordeDefault = const Color(0xFFD2B48C),
  });

  @override
  GuardiaTheme copyWith({
    Color? mantenimiento,
    Color? reparacion,
    Color? noLlego,
    Color? bordeDefault,
  }) {
    return GuardiaTheme(
      mantenimiento: mantenimiento ?? this.mantenimiento,
      reparacion: reparacion ?? this.reparacion,
      noLlego: noLlego ?? this.noLlego,
      bordeDefault: bordeDefault ?? this.bordeDefault,
    );
  }

  @override
  ThemeExtension<GuardiaTheme> lerp(
    covariant ThemeExtension<GuardiaTheme>? other,
    double t,
  ) {
    if (other is! GuardiaTheme) return this;

    return GuardiaTheme(
      mantenimiento: Color.lerp(mantenimiento, other.mantenimiento, t)!,
      reparacion: Color.lerp(reparacion, other.reparacion, t)!,
      noLlego: Color.lerp(noLlego, other.noLlego, t)!,
      bordeDefault: Color.lerp(bordeDefault, other.bordeDefault, t)!,
    );
  }
}