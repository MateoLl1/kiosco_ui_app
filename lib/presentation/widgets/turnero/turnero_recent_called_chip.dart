import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurneroRecentCalledChip extends StatelessWidget {
  final Turno turno;

  const TurneroRecentCalledChip({
    super.key,
    required this.turno,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            turno.turno,
            style: TextStyle(
              color: colors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            turno.nombreCliente,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}