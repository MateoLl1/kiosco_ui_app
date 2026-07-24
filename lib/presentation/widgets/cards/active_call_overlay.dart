import 'dart:ui';
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
  // Entrada del card
  late final AnimationController _enterCtrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _slideAnim;

  // Anillos de radar pulsantes
  late final AnimationController _radarCtrl;

  // Aparición escalonada del contenido
  late final AnimationController _contentCtrl;
  late final Animation<double> _nameAnim;
  late final Animation<double> _badgeAnim;

  @override
  void initState() {
    super.initState();

    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _scaleAnim = Tween<double>(begin: 0.80, end: 1.0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<double>(begin: 48.0, end: 0.0).animate(
      CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic),
    );

    _radarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _nameAnim = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.30, 1.0, curve: Curves.easeOut),
    );
    _badgeAnim = CurvedAnimation(
      parent: _contentCtrl,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );

    if (widget.turno != null) _playEntrance();
  }

  void _playEntrance() {
    _enterCtrl.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 260), () {
      if (mounted) _contentCtrl.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(ActiveCallOverlay old) {
    super.didUpdateWidget(old);
    if (widget.turno != null && old.turno == null) _playEntrance();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _radarCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Widget _radarRing(Color color, double offset) {
    return AnimatedBuilder(
      animation: _radarCtrl,
      builder: (_, __) {
        final t = (_radarCtrl.value + offset) % 1.0;
        final size = 160.0 + 100.0 * t;
        final opacity = (1.0 - t) * 0.55;
        return SizedBox(
          width: size,
          height: size,
          child: Opacity(
            opacity: opacity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.turno == null) return const SizedBox.shrink();

    final colors = Theme.of(context).colorScheme;
    final turno = widget.turno!;
    final tieneNombre = turno.nombreCliente.trim().isNotEmpty;

    return IgnorePointer(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 280),
        opacity: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Fondo con blur ───────────────────────────────────────
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: colors.scrim.withValues(alpha: 0.62),
              ),
            ),

            // ── Card centrado con animación ──────────────────────────
            Center(
              child: AnimatedBuilder(
                animation: _enterCtrl,
                builder: (_, child) => FadeTransition(
                  opacity: _fadeAnim,
                  child: Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: ScaleTransition(scale: _scaleAnim, child: child),
                  ),
                ),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 520, minWidth: 360),
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.45),
                        blurRadius: 70,
                        spreadRadius: -4,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Barra degradada superior
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary,
                                Color.lerp(colors.primary, colors.tertiary, 0.5)!,
                                colors.tertiary,
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(36, 28, 36, 34),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Chip "TURNO LLAMADO"
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: colors.primary.withValues(alpha: 0.28),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.notifications_active_rounded,
                                      color: colors.primary,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      'TURNO LLAMADO',
                                      style: TextStyle(
                                        color: colors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              // ── Anillos radar + número ────────────
                              SizedBox(
                                width: 260,
                                height: 260,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    _radarRing(colors.primary, 0.0),
                                    _radarRing(colors.primary, 0.45),

                                    // Círculo de fondo con glow
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            colors.primary.withValues(alpha: 0.18),
                                            colors.primary.withValues(alpha: 0.04),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.primary.withValues(alpha: 0.28),
                                            blurRadius: 28,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Número de turno
                                    SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          turno.turno,
                                          style: TextStyle(
                                            color: colors.primary,
                                            fontSize: 82,
                                            fontWeight: FontWeight.w900,
                                            height: 1,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Nombre cliente (aparece escalonado)
                              if (tieneNombre)
                                FadeTransition(
                                  opacity: _nameAnim,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.3),
                                      end: Offset.zero,
                                    ).animate(_nameAnim),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        turno.nombreCliente,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: colors.onSurface,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // Badge módulo (aparece escalonado)
                              FadeTransition(
                                opacity: _badgeAnim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.4),
                                    end: Offset.zero,
                                  ).animate(_badgeAnim),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 11,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          colors.primaryContainer,
                                          Color.lerp(
                                            colors.primaryContainer,
                                            colors.secondaryContainer,
                                            0.45,
                                          )!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.sensor_door_outlined,
                                          size: 18,
                                          color: colors.onPrimaryContainer,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Acercarse al Módulo ${turno.modulo}',
                                          style: TextStyle(
                                            color: colors.onPrimaryContainer,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
          ],
        ),
      ),
    );
  }
}
