import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class ActiveCallOverlay extends StatefulWidget {
  final Turno? turno;

  const ActiveCallOverlay({super.key, required this.turno});

  @override
  State<ActiveCallOverlay> createState() => _ActiveCallOverlayState();
}

class _ActiveCallOverlayState extends State<ActiveCallOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOutBack);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);

    if (widget.turno != null) _scaleCtrl.forward();
  }

  @override
  void didUpdateWidget(ActiveCallOverlay old) {
    super.didUpdateWidget(old);
    if (widget.turno != null && old.turno == null) {
      _scaleCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.turno == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    final turno = widget.turno!;
    final tieneNombre = turno.nombreCliente.trim().isNotEmpty;

    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: 1,
        child: Container(
          color: colors.scrim.withValues(alpha: 0.60),
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 640, minWidth: 400),
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.30),
                    blurRadius: 56,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            Color.lerp(colors.primary, colors.secondary, 0.30)!,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_active_rounded,
                            color: colors.onPrimary,
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'TURNO LLAMADO',
                            style: TextStyle(
                              color: colors.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Body ────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 32, 40, 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Número de turno con glow pulsante
                          AnimatedBuilder(
                            animation: _pulseAnim,
                            builder: (context, child) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 52,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.07),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colors.primary.withValues(
                                    alpha: 0.18 + 0.28 * _pulseAnim.value,
                                  ),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.primary.withValues(
                                      alpha: 0.06 + 0.20 * _pulseAnim.value,
                                    ),
                                    blurRadius: 20 + 20 * _pulseAnim.value,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                            child: Text(
                              turno.turno,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 86,
                                fontWeight: FontWeight.w900,
                                height: 1,
                                letterSpacing: -1,
                              ),
                            ),
                          ),

                          if (tieneNombre) ...[
                            const SizedBox(height: 20),
                            Text(
                              turno.nombreCliente,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Badge módulo
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.sensor_door_outlined,
                                  size: 20,
                                  color: colors.onPrimaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Módulo ${turno.modulo}',
                                  style: TextStyle(
                                    color: colors.onPrimaryContainer,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
