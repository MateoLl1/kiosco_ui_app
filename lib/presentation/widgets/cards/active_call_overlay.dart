import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class ActiveCallOverlay extends StatelessWidget {
  final Turno? turno;

  const ActiveCallOverlay({
    super.key,
    required this.turno,
  });

  @override
  Widget build(BuildContext context) {
    if (turno == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;

    return IgnorePointer(
      ignoring: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: turno == null ? 0 : 1,
        child: Container(
          color: colors.scrim.withValues(alpha: 0.45),
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 760,
              minWidth: 520,
            ),
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 28,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: 46,
                  color: colors.primary,
                ),
                const SizedBox(height: 14),
                Text(
                  'TURNO LLAMADO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  turno!.turno,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 68,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  turno!.nombreCliente,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface.withValues(alpha: 0.88),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Acercarse al módulo ${turno!.modulo}',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}