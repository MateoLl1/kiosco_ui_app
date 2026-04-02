import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final pantallaTurnosProvider = StateNotifierProvider.autoDispose<
    PantallaTurnosNotifier, AsyncValue<PantallaTurnosResponse>>((ref) {
  final repository = ref.watch(kioscoRepositoryProvider);
  final session = ref.watch(appSessionProvider);

  final notifier = PantallaTurnosNotifier(
    repository: repository,
    agenciaId: session?.agenciaId,
  );

  ref.onDispose(() {
    notifier.disposeTimer();
  });

  return notifier;
});

class PantallaTurnosNotifier
    extends StateNotifier<AsyncValue<PantallaTurnosResponse>> {
  final KioscoRepository repository;
  final int? agenciaId;
  Timer? _timer;

  PantallaTurnosNotifier({
    required this.repository,
    required this.agenciaId,
  }) : super(const AsyncLoading()) {
    loadPantalla();
    _startAutoRefresh();
  }

  Future<void> loadPantalla() async {
    if (agenciaId == null) {
      state = AsyncError('No hay agencia configurada', StackTrace.current);
      return;
    }

    try {
      final response = await repository.getPantallaTurnos(agenciaId!);
      state = AsyncData(response);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  void _startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      loadPantalla();
    });
  }

  void disposeTimer() {
    _timer?.cancel();
  }
}