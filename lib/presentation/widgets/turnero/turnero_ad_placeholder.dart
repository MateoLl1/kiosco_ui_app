import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';


class TurneroAdPlaceholder extends StatelessWidget {
  final Turno? turnoActual;
  final List<Turno> recienLlamados;

  const TurneroAdPlaceholder({
    super.key,
    required this.turnoActual,
    required this.recienLlamados,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.2),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surface,
            colors.primary.withValues(alpha: 0.08),
            colors.secondary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'ESPACIO PUBLICITARIO',
              style: TextStyle(
                color: colors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aquí puedes mostrar campañas,\nimágenes o videos mientras\nlos clientes esperan.',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 30,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Por ahora se deja un placeholder visual.',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            if (turnoActual != null)
              TurneroCurrentTurnCard(turno: turnoActual!),
            if (recienLlamados.isNotEmpty) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: recienLlamados
                    .take(3)
                    .map((t) => TurneroRecentCalledChip(turno: t))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}