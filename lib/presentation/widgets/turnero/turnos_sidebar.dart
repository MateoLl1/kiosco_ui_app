


import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TurnosSidebar extends StatelessWidget {
  final List<Turno> pendientes;

  const TurnosSidebar({
    super.key,
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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: pendientes.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: colors.outline.withValues(alpha: 0.2),
                    ),
                    itemBuilder: (context, index) {
                      final turno = pendientes[index];
                      return TurnosSidebarItem(turno: turno);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}