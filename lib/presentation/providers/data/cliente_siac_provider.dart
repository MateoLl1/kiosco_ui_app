import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final clienteSiacProvider =
    StateNotifierProvider<ClienteSiacNotifier, ClienteSiac?>((ref) {
  final repository = ref.watch(kioscoRepositoryProvider);

  return ClienteSiacNotifier(
    repository: repository,
  );
});

class ClienteSiacNotifier extends StateNotifier<ClienteSiac?> {
  final KioscoRepository repository;

  ClienteSiacNotifier({
    required this.repository,
  }) : super(null);

  Future<ClienteSiac?> consultarCliente({
    required String identificacion,
    required int agenciaId,
  }) async {
    limpiar();

    final cliente = await repository.obtenerClientePorIdentificacion(
      identificacion: identificacion,
      agenciaId: agenciaId,
    );

    state = cliente;
    return cliente;
  }

  void limpiar() {
    state = null;
  }
}