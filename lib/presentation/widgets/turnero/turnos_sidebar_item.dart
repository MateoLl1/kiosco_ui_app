import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurnosSidebarItem extends StatelessWidget {
  final Turno turno;

  const TurnosSidebarItem({
    super.key,
    required this.turno,
  });

  String _formatTipo(String tipo) {
    switch (tipo) {
      case 'con_cita':
        return 'Con cita';
      case 'sin_cita':
        return 'Sin cita';
      default:
        return tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final hour = turno.fechaReferencia != null
        ? DateFormat('HH:mm').format(turno.fechaReferencia!)
        : '--:--';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.person_outline,
              color: colors.onSurface.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${turno.turno}  ',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: turno.nombreCliente,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatTipo(turno.tipo)}  •  $hour',
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.65),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}