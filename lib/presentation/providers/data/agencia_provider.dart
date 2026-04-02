


import 'package:flutter_riverpod/legacy.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';



final agenciaProvider = StateNotifierProvider<AgenciaNotifier, List<Agencia>>((ref) {
  final repository = ref.watch(agenciaRepositoryProvider);
  return AgenciaNotifier(repository: repository);
});



class AgenciaNotifier extends StateNotifier<List<Agencia>> {
  
  final AgenciasRepository repository;

  AgenciaNotifier({required this.repository}): super([]);
  

  Future<void> loadAgencias() async {
      final agencias = await repository.getAgencias();
      state = [...agencias];
  }
}