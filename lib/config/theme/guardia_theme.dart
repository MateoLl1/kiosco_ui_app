import 'package:flutter/material.dart';

class GuardiaTheme extends ThemeExtension<GuardiaTheme> {
  final Color mantenimiento;
  final Color reparacion;
  final Color noLlego;
  final Color cancelado;
  final Color defaultColor;

  const GuardiaTheme({
    this.mantenimiento = const Color(0xFF8080FF),
    this.reparacion = const Color(0xFFFFC080),
    this.noLlego = Colors.red,
    this.cancelado = Colors.red,
    this.defaultColor = const Color(0xFFFAFAD2),
  });

  @override
  GuardiaTheme copyWith({
    Color? mantenimiento,
    Color? reparacion,
    Color? noLlego,
    Color? cancelado,
    Color? defaultColor,
  }) {
    return GuardiaTheme(
      mantenimiento: mantenimiento ?? this.mantenimiento,
      reparacion: reparacion ?? this.reparacion,
      noLlego: noLlego ?? this.noLlego,
      cancelado: cancelado ?? this.cancelado,
      defaultColor: defaultColor ?? this.defaultColor,
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
      cancelado: Color.lerp(cancelado, other.cancelado, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
    );
  }
}