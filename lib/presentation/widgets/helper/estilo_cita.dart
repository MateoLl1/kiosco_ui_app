import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';

/// El estado manda sobre el tipo de labor: una cita cancelada o que no
/// llegó se pinta por su estado sin importar qué labor tenía agendada.
/// Si está agendada/confirmada, se pinta por su tipo de labor real — antes
/// esto se resolvía con un solo campo que agrupaba Reparación, Recepción y
/// Servicios Rápidos bajo el mismo color "reparación", lo que hacía parecer
/// que los tres se comportan igual cuando solo Reparación y Recepción nunca
/// pasan directo a bahía y Servicios Rápidos sí puede.
Color resolverColorCita(
  GuardiaTheme guardia,
  String estado,
  String tipoLabor,
) {
  switch (estado.toLowerCase().trim()) {
    case 'cancelado':
      return guardia.cancelado;
    case 'no_llego':
      return guardia.noLlego;
  }

  switch (tipoLabor.toLowerCase().trim()) {
    case 'mantenimiento':
      return guardia.mantenimiento;
    case 'reparacion':
      return guardia.reparacion;
    case 'recepcion':
      return guardia.recepcion;
    case 'servicio_rapido':
      return guardia.servicioRapido;
    default:
      return guardia.defaultColor;
  }
}