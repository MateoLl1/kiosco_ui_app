import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

Future<void> generarTurnoSinCitaGuardia({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final session = ref.read(appSessionProvider);
  final repository = ref.read(kioscoRepositoryProvider);

  if (session == null || session.agenciaId == null) {
    _mostrarError(context, 'No existe una sesión activa.');
    return;
  }

  try {
    final response = await repository.generarTurnoSinCita(
      agenciaId: session.agenciaId!,
    );

    if (!context.mounted) return;

    await mostrarTurnoGeneradoGuardia(
      context: context,
      turno: response.turno,
      mensaje: 'Turno generado correctamente.',
    );
  } catch (_) {
    if (!context.mounted) return;
    _mostrarError(context, 'No se pudo generar el turno sin cita.');
  }
}

Future<void> generarTurnoSinCitaFlotasGuardia({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final session = ref.read(appSessionProvider);
  final repository = ref.read(kioscoRepositoryProvider);

  if (session == null || session.agenciaId == null) {
    _mostrarError(context, 'No existe una sesión activa.');
    return;
  }

  try {
    final response = await repository.generarTurnoSinCitaFlotas(
      agenciaId: session.agenciaId!,
    );

    if (!context.mounted) return;

    await mostrarTurnoGeneradoGuardia(
      context: context,
      turno: response.turno,
      mensaje: 'Turno generado correctamente.',
    );
  } catch (_) {
    if (!context.mounted) return;
    _mostrarError(context, 'No se pudo generar el turno de flotas.');
  }
}

void _mostrarError(BuildContext context, String mensaje) {
  final colors = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colors.error,
      content: Text(
        mensaje,
        style: TextStyle(
          color: colors.onError,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}