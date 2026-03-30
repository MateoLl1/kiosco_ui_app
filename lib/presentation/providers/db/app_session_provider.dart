

import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final appSessionProvider =
    StateNotifierProvider<AppSessionNotifier, AppSessionConfig?>((ref) {
  final repository = ref.watch(localStorageRepositoryProvider);
  return AppSessionNotifier(repository: repository);
});

class AppSessionNotifier extends StateNotifier<AppSessionConfig?> {
  final LocalStorageRepository repository;

  AppSessionNotifier({required this.repository}) : super(null);

  Future<void> loadSession() async {
    final session = await repository.getSession();
    state = session;
  }

  Future<void> saveSession({
    required int agenciaId,
    required AppRole role,
  }) async {
    final session = AppSessionConfig(
      agenciaId: agenciaId,
      role: role,
    );

    await repository.saveSession(session);
    state = session;
  }

  Future<void> clearSession() async {
    await repository.clearSession();
    state = null;
  }

  bool get hasSession => state != null;
  bool get isGuardia => state?.role == AppRole.guardia;
  bool get isKiosco => state?.role == AppRole.kiosco;
  bool get isTurnero => state?.role == AppRole.turnero;
}