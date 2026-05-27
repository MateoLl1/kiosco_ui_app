import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final turnoKioscoProvider =
    StateNotifierProvider<TurnoKioscoNotifier, TurnoKiosco?>((ref) {
  final repository = ref.watch(kioscoRepositoryProvider);

  return TurnoKioscoNotifier(
    repository: repository,
  );
});

class TurnoKioscoNotifier extends StateNotifier<TurnoKiosco?> {
  final KioscoRepository repository;

  TurnoKioscoNotifier({
    required this.repository,
  }) : super(null);

  Future<TurnoKiosco> generarTurno({
    required int agenciaId,
    required double clCodigo,
  }) async {
    final turno = await repository.generarTurnoKiosco(
      agenciaId: agenciaId,
      clCodigo: clCodigo,
    );

    state = turno;
    return turno;
  }

  void limpiar() {
    state = null;
  }
}