



// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

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

EstiloCita resolverEstiloCita(ColorScheme colors, String claveVisual) {
  switch (claveVisual.toLowerCase()) {
    case 'cancelado':
      return EstiloCita(
        fondo: colors.errorContainer,
        borde: colors.error,
        texto: colors.onErrorContainer,
        textoSecundario: colors.onErrorContainer.withOpacity(0.82),
      );
    case 'no_llego':
      return EstiloCita(
        fondo: colors.error,
        borde: colors.error,
        texto: colors.onError,
        textoSecundario: colors.onError.withOpacity(0.82),
      );
    case 'mantenimiento':
      return EstiloCita(
        fondo: colors.primaryContainer,
        borde: colors.primary,
        texto: colors.onPrimaryContainer,
        textoSecundario: colors.onPrimaryContainer.withOpacity(0.82),
      );
    case 'reparacion':
      return EstiloCita(
        fondo: colors.secondaryContainer,
        borde: colors.secondary,
        texto: colors.onSecondaryContainer,
        textoSecundario: colors.onSecondaryContainer.withOpacity(0.82),
      );
    case 'servicio_rapido':
      return EstiloCita(
        fondo: colors.tertiaryContainer,
        borde: colors.tertiary,
        texto: colors.onTertiaryContainer,
        textoSecundario: colors.onTertiaryContainer.withOpacity(0.82),
      );
    default:
      return EstiloCita(
        fondo: colors.surfaceContainerHighest,
        borde: colors.outlineVariant,
        texto: colors.onSurface,
        textoSecundario: colors.onSurfaceVariant,
      );
  }
}