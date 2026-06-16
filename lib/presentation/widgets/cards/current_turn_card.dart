import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class CurrentTurnCard extends StatelessWidget {
  const CurrentTurnCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Panel(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'TURNO ACTUAL',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 14),

          Container(
            width: 150,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: .7),
                width: 1.4,
              ),
            ),
            child: Text(
              '-',
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 48,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Sin turno en atención',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: 448,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: 'Llamar siguiente',
                        icon: Icons.phone_in_talk_rounded,
                        background: colors.primary,
                        foreground: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        text: 'Re-llamar',
                        icon: Icons.replay_rounded,
                        background: colors.surfaceContainerHighest,
                        foreground: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: 'Atendido',
                        icon: Icons.check_circle_outline_rounded,
                        background: colors.tertiaryContainer,
                        foreground: colors.onTertiaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ActionButton(
                        text: 'Saltar',
                        icon: Icons.skip_next_rounded,
                        background: colors.errorContainer,
                        foreground: colors.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}