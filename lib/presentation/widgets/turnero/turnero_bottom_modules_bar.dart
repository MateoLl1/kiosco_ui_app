import 'package:flutter/material.dart';

const _kGreen = Color(0xFF22C55E);
const _kRed = Color(0xFFEF4444);

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
          final enAtencion = activeModulos.contains(module.toString());
          final dotColor = enAtencion ? _kRed : _kGreen;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: enAtencion ? 10 : 8,
                  height: enAtencion ? 10 : 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.50),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'MÓDULO $module',
                  style: TextStyle(
                    color: enAtencion
                        ? colors.onSurface
                        : colors.onSurface.withValues(alpha: 0.70),
                    fontSize: 12,
                    fontWeight: enAtencion ? FontWeight.w800 : FontWeight.w600,
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
