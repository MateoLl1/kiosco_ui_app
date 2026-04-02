import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final databookProvider =
    StateNotifierProvider<DatabookNotifier, Databook?>((ref) {
  final repository = ref.watch(infoCreditoRepositoryProvider);
  return DatabookNotifier(
    ref: ref,
    repository: repository,
  );
});

class DatabookNotifier extends StateNotifier<Databook?> {
  final Ref ref;
  final InfoCreditoRepository repository;

  DatabookNotifier({
    required this.ref,
    required this.repository,
  }) : super(null);

  Future<void> consultarPerfilDatabook({
    required String identificacion,
    int empresa = 1,
  }) async {
    final token = await ref.read(authTokenProvider.notifier).getToken();

    final databook = await repository.getPerfilDatabook(
      token: token,
      identificacion: identificacion,
      empresa: empresa,
    );

    state = databook;
  }

  void limpiar() {
    state = null;
  }
}