import 'package:flutter/material.dart';

/// Un color por cada tipo de labor que realmente aparece en el kiosco
/// (TL_CODIGO 5/8/17/18), más los dos estados que no son un tipo de labor
/// sino un estatus de la cita (cancelado, no llegó). mantenimiento y
/// reparacion vienen del color legacy de SI_TIPO_LABOR (TL_COLOR, formato
/// OLE &H00BBGGRR) para no inventar una paleta nueva encima de la que ya
/// usa el asesor en el sistema viejo; recepcion y servicioRapido igual.
class GuardiaTheme extends ThemeExtension<GuardiaTheme> {
  final Color mantenimiento;
  final Color reparacion;
  final Color recepcion;
  final Color servicioRapido;
  final Color cancelado;
  final Color noLlego;
  final Color defaultColor;

  const GuardiaTheme({
    this.mantenimiento = const Color(0xFF8080FF),
    this.reparacion = const Color(0xFFFFC080),
    this.recepcion = const Color(0xFFFF8000),
    this.servicioRapido = const Color(0xFFFF80FF),
    this.cancelado = Colors.red,
    this.noLlego = const Color(0xFF9E9E9E),
    this.defaultColor = const Color(0xFFFAFAD2),
  });

  @override
  GuardiaTheme copyWith({
    Color? mantenimiento,
    Color? reparacion,
    Color? recepcion,
    Color? servicioRapido,
    Color? cancelado,
    Color? noLlego,
    Color? defaultColor,
  }) {
    return GuardiaTheme(
      mantenimiento: mantenimiento ?? this.mantenimiento,
      reparacion: reparacion ?? this.reparacion,
      recepcion: recepcion ?? this.recepcion,
      servicioRapido: servicioRapido ?? this.servicioRapido,
      cancelado: cancelado ?? this.cancelado,
      noLlego: noLlego ?? this.noLlego,
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
      recepcion: Color.lerp(recepcion, other.recepcion, t)!,
      servicioRapido: Color.lerp(servicioRapido, other.servicioRapido, t)!,
      cancelado: Color.lerp(cancelado, other.cancelado, t)!,
      noLlego: Color.lerp(noLlego, other.noLlego, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
    );
  }
}