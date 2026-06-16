import 'package:flutter/material.dart';

class MostradorHeader extends StatelessWidget {
  const MostradorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [

        Text(
          'MOSTRADOR • REPUESTOS',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest.withValues(alpha: .45),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: .45),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups_rounded, size: 18, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  '2',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'en espera',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}