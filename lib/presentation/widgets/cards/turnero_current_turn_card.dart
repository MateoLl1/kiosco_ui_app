import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurneroCurrentTurnCard extends StatelessWidget {
  final Turno turno;

  const TurneroCurrentTurnCard({
    super.key,
    required this.turno,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TURNO ACTUAL',
            style: TextStyle(
              color: colors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            turno.turno,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            turno.nombreCliente,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.85),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Módulo ${turno.modulo}',
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}