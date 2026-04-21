import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';

class EstiloCita {
  final Color fondo;
  final Color borde;
  final Color texto;
  final Color textoSecundario;

  const EstiloCita({
    required this.fondo,
    required this.borde,
    required this.texto,
    required this.textoSecundario,
  });
}

EstiloCita resolverEstiloCita(
  GuardiaTheme guardia,
  ColorScheme colors,
  String claveVisual,
) {
  switch (claveVisual.toLowerCase()) {
    case 'mantenimiento':
      return EstiloCita(
        fondo: colors.surfaceContainerHighest,
        borde: guardia.mantenimiento,
        texto: colors.onSurface,
        textoSecundario: colors.onSurfaceVariant,
      );

    case 'reparacion':
      return EstiloCita(
        fondo: colors.surfaceContainerHighest,
        borde: guardia.reparacion,
        texto: colors.onSurface,
        textoSecundario: colors.onSurfaceVariant,
      );

    case 'no_llego':
      return EstiloCita(
        fondo: colors.surfaceContainerHighest,
        borde: guardia.noLlego,
        texto: colors.onSurface,
        textoSecundario: colors.onSurfaceVariant,
      );

    default:
      return EstiloCita(
        fondo: colors.surfaceContainerHighest,
        borde: guardia.bordeDefault,
        texto: colors.onSurface,
        textoSecundario: colors.onSurfaceVariant,
      );
  }
}
