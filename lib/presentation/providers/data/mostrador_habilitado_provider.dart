import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final mostradorHabilitadoProvider =
    FutureProvider.family<bool, int>((ref, agenciaId) async {
  if (agenciaId <= 0) return false;
  return ref
      .read(kioscoRepositoryProvider)
      .verificarMostradorHabilitado(agenciaId: agenciaId);
});
