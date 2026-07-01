import 'package:flutter/material.dart';

class GuardiaHeader extends StatelessWidget {
  final String? agenciaNombre;

  const GuardiaHeader({
    super.key,
    required this.agenciaNombre,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isWide ? 24 : 16,
        12,
        isWide ? 24 : 16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            agenciaNombre ?? 'Guardia',
            style: TextStyle(
              fontSize: isWide ? 32 : 24,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.swipe_up_rounded,
                size: isWide ? 14 : 13,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'Desliza hacia abajo para actualizar',
                style: TextStyle(
                  fontSize: isWide ? 13 : 12,
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}