import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

final turneroMediaProvider = FutureProvider.family<List<TurneroMedia>, int>((
  ref,
  agenciaId,
) async {
  if (agenciaId <= 0) return [];

  final repository = ref.watch(kioscoRepositoryProvider);

  final lista = await repository.getTurneroMediaPorAgencia(
    agenciaId: agenciaId,
  );

  final filtrada = lista.where((item) {
    final tipo = item.tipo.trim().toLowerCase();
    return item.url.trim().isNotEmpty && (tipo == 'imagen' || tipo == 'video');
  }).toList();

  filtrada.sort((a, b) {
    final ordenA = a.orden ?? 0;
    final ordenB = b.orden ?? 0;

    final cmpOrden = ordenA.compareTo(ordenB);
    if (cmpOrden != 0) return cmpOrden;

    return a.codigo.compareTo(b.codigo);
  });

  return filtrada;
});