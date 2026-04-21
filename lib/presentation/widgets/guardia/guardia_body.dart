import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaBody extends ConsumerWidget {
  final AsyncValue<List<Cita>> state;
  final Future<void> Function() onRefresh;

  const GuardiaBody({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return state.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.error,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      data: (citas) {
        if (citas.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No hay citas disponibles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            const GuardiaTablaHeader(),
            const SizedBox(height: 8),
            ...List.generate(citas.length, (index) {
              final cita = citas[index];

              return Padding(
                padding: EdgeInsets.only(bottom: index == citas.length - 1 ? 0 : 8),
                child: CitaTitle(
                  cita: cita,
                  onTap: () => ejecutarAccionCitaGuardia(
                    context: context,
                    ref: ref,
                    cita: cita,
                    onRefresh: onRefresh,
                  ),
                ),
              );

            }),
          ],
        );
      },
    );
  }
}