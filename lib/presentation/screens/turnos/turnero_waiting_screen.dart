


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TurneroWaitingScreen extends ConsumerWidget {
  const TurneroWaitingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pantallaTurnosProvider);
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesa de espera'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(pantallaTurnosProvider.notifier).loadPantalla();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (data) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(pantallaTurnosProvider.notifier).loadPantalla(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SectionTitle(
                  title: 'Turno actual',
                  icon: Icons.campaign_outlined,
                ),
                const SizedBox(height: 12),
                if (data.turnoActual != null)
                  TurnoActualCard(turno: data.turnoActual!)
                else
                  const EmptyCard(
                    message: 'No hay turno actual en atención',
                  ),
                const SizedBox(height: 20),
                SectionTitle(
                  title: 'Recién llamados',
                  icon: Icons.history,
                ),
                const SizedBox(height: 12),
                if (data.turnosRecienLlamados.isEmpty)
                  const EmptyCard(
                    message: 'No hay turnos recién llamados',
                  )
                else
                  ...data.turnosRecienLlamados.map(
                    (turno) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TurnoCompactCard(turno: turno),
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.people_alt_outlined, color: colors.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Turnos pendientes (${data.turnosPendientes.length})',
                      style: textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (data.turnosPendientes.isEmpty)
                  const EmptyCard(
                    message: 'No hay turnos pendientes',
                  )
                else
                  ...data.turnosPendientes.map(
                    (turno) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TurnoPendienteCard(turno: turno),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

