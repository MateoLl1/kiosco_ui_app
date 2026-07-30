import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TurnosSidebar extends StatelessWidget {
  final List<Turno> turnosActivos;
  final List<Turno> pendientes;

  const TurnosSidebar({
    super.key,
    required this.turnosActivos,
    required this.pendientes,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          left: BorderSide(
            color: colors.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── EN ATENCIÓN ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colors.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.headset_mic_rounded,
                      color: colors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'EN ATENCIÓN',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (turnosActivos.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${turnosActivos.length}',
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (turnosActivos.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Ningún módulo en atención',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                )
              else
                ...(List<Turno>.from(turnosActivos)
                        ..sort((a, b) => (b.fechaReferencia ?? DateTime(0))
                            .compareTo(a.fechaReferencia ?? DateTime(0))))
                    .take(2)
                    .map((t) => FadeIn(child: TurneroCurrentSidebarCard(turno: t))),
              const SizedBox(height: 8),
            ],
          ),

          // ── Divider ──
          Divider(height: 1, color: colors.outline.withValues(alpha: 0.2)),

          // ── EN ESPERA ──
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: colors.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'EN ESPERA',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${pendientes.length}',
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: pendientes.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No hay turnos en espera',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.7),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 8),
                    itemCount: pendientes.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      indent: 12,
                      endIndent: 12,
                      color: colors.outline.withValues(alpha: 0.12),
                    ),
                    itemBuilder: (context, index) {
                      final turno = pendientes[index];
                      return FadeInRight(
                        child: TurnosSidebarItem(turno: turno, index: index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
