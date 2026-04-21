import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';

Color resolverColorCita(
  GuardiaTheme guardia,
  String claveVisual,
) {
  switch (claveVisual.toLowerCase().trim()) {
    case 'mantenimiento':
      return guardia.mantenimiento;

    case 'reparacion':
      return guardia.reparacion;

    case 'cancelado':
      return guardia.cancelado;

    default:
      return guardia.defaultColor;
  }
}