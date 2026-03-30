

import 'package:flutter/material.dart';

class TurneroBottomModulesBar extends StatelessWidget {
  const TurneroBottomModulesBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final modules = ['MÓDULO 1', 'MÓDULO 2', 'MÓDULO 3', 'MÓDULO 4', 'MÓDULO 5'];

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: modules
            .map(
              (module) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      module,
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}