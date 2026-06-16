import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class QueueCard extends StatelessWidget {
  const QueueCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'En espera',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '2 turno(s)',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          const QueueItem(
            code: 'T-040',
            name: 'Luis Andrade',
            time: 'espera 1485 min',
            isNext: true,
          ),

          const SizedBox(height: 10),

          const QueueItem(
            code: 'T-041',
            name: 'Ana Suárez',
            time: 'espera 1482 min',
          ),

          const SizedBox(height: 26),

          Text(
            'RECIENTES',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Sin historial',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}