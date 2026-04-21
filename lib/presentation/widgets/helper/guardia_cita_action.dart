// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';


Future<void> ejecutarAccionCitaGuardia({
  required BuildContext context,
  required WidgetRef ref,
  required Cita cita,
  required Future<void> Function() onRefresh,
}) async {
  final confirmado = await mostrarConfirmacionGuardia(
    context: context,
    cita: cita,
  );

  if (confirmado != true) return;

  final session = ref.read(appSessionProvider);
  final repository = ref.read(kioscoRepositoryProvider);

  if (session == null || session.agenciaId == null) {
    mostrarErrorGuardia(context, 'No existe una sesión activa.');
    return;
  }

  try {
    final response = await repository.registrarLlegada(
      agenciaId: session.agenciaId!,
      citaId: cita.codigoCita,
    );

    if (!context.mounted) return;

    await mostrarTurnoGeneradoGuardia(
      context: context,
      turno: response.turno,
      mensaje: response.mensaje,
    );

    await onRefresh();
  } catch (_) {
    if (!context.mounted) return;
    mostrarErrorGuardia(context, 'No se pudo registrar la llegada.');
  }
}