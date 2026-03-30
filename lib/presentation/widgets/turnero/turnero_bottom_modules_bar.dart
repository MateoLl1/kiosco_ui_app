import 'package:flutter/material.dart';

class TurneroBottomModulesBar extends StatelessWidget {
  final String? activeModulo;

  const TurneroBottomModulesBar({
    super.key,
    this.activeModulo,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final modules = ['1', '2', '3', '4', '5'];

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
        children: modules.map((module) {
          final isActive = activeModulo?.trim() == module.trim();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: isActive ? 12 : 10,
                  height: isActive ? 12 : 10,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colors.primary
                        : colors.primary.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: colors.primary.withValues(alpha: 0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'MÓDULO $module',
                  style: TextStyle(
                    color: isActive
                        ? colors.onSurface
                        : colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight:
                        isActive ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}