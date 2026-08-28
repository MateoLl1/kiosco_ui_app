import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurnosSidebarItem extends StatelessWidget {
  final Turno turno;
  final int index;

  const TurnosSidebarItem({
    super.key,
    required this.turno,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isNext = index == 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: isNext
                  ? colors.primaryContainer.withValues(alpha: 0.55)
                  : colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isNext
                    ? colors.primary.withValues(alpha: 0.35)
                    : colors.outline.withValues(alpha: 0.20),
              ),
            ),
            child: Text(
              turno.turno,
              style: TextStyle(
                color: colors.primary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  turno.nombreCliente.trim().isNotEmpty
                      ? turno.nombreCliente.trim()
                      : '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.88),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isNext)
                  Text(
                    'Siguiente',
                    style: TextStyle(
                      color: colors.primary.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
