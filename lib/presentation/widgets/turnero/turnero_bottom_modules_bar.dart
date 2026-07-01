import 'package:flutter/material.dart';

const _kGreen = Color(0xFF22C55E);

class TurneroBottomModulesBar extends StatelessWidget {
  final Set<String> activeModulos;
  final List<int> modulosActivos;

  const TurneroBottomModulesBar({
    super.key,
    this.activeModulos = const {},
    this.modulosActivos = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (modulosActivos.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: modulosActivos.map((module) {
          final isActive = activeModulos.contains(module.toString());

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isActive ? 10 : 8,
                  height: isActive ? 10 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _kGreen
                        : colors.onSurface.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: _kGreen.withValues(alpha: 0.50),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'MÓDULO $module',
                  style: TextStyle(
                    color: isActive
                        ? colors.onSurface
                        : colors.onSurface.withValues(alpha: 0.40),
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
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
