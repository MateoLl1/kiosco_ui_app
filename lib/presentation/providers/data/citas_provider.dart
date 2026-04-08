


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final citasGuardiaProvider =
    StateNotifierProvider.autoDispose<CitasNotifier, AsyncValue<List<Cita>>>((ref) {
  final repository = ref.watch(kioscoRepositoryProvider);
  final session = ref.watch(appSessionProvider);

  return CitasNotifier(
    repository: repository,
    agenciaId: session?.agenciaId,
  );
});

class CitasNotifier extends StateNotifier<AsyncValue<List<Cita>>> {
  final KioscoRepository repository;
  final int? agenciaId;

  CitasNotifier({
    required this.repository,
    required this.agenciaId,
  }) : super(const AsyncLoading()) {
    loadCitas();
  }

  Future<void> loadCitas() async {
    if (agenciaId == null) {
      state = AsyncError('No hay agencia configurada', StackTrace.current);
      return;
    }

    try {
      final citas = await repository.listarCitas(agenciaId!);
      state = AsyncData(citas);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}