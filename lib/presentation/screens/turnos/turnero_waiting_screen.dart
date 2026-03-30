import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TurneroWaitingScreen extends ConsumerStatefulWidget {
  const TurneroWaitingScreen({super.key});

  @override
  ConsumerState<TurneroWaitingScreen> createState() =>
      _TurneroWaitingScreenState();
}

class _TurneroWaitingScreenState extends ConsumerState<TurneroWaitingScreen> {
  DateTime now = DateTime.now();
  int? ultimoTurnoMostrado;
  Turno? activeOverlayTurno;
  Timer? overlayTimer;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(pantallaTurnosProvider.notifier).loadPantalla();
    });

    _startClock();
  }

  @override
  void dispose() {
    overlayTimer?.cancel();
    super.dispose();
  }

  void _startClock() {
    Future.doWhile(() async {
      if (!mounted) return false;
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        now = DateTime.now();
      });

      return true;
    });
  }

  void _handleOverlayTurno(Turno? turnoActual) {
    if (turnoActual == null) return;

    if (ultimoTurnoMostrado == turnoActual.asgCodigo) return;

    ultimoTurnoMostrado = turnoActual.asgCodigo;
    activeOverlayTurno = turnoActual;

    overlayTimer?.cancel();
    overlayTimer = Timer(const Duration(seconds: 8), () {
      if (!mounted) return;
      setState(() {
        activeOverlayTurno = null;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pantallaTurnosProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: state.when(
          loading: () => Center(
            child: CircularProgressIndicator(
              color: colors.primary,
            ),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSurface,
                ),
              ),
            ),
          ),
          data: (data) {
            _handleOverlayTurno(data.turnoActual);

            return Stack(
              children: [
                Column(
                  children: [
                    TurneroHeader(now: now),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 16, 12, 12),
                              child: TurneroAdPlaceholder(
                                recienLlamados: data.turnosRecienLlamados,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 340,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 16, 0, 12),
                              child: TurnosSidebar(
                                turnoActual: data.turnoActual,
                                pendientes: data.turnosPendientes,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TurneroBottomModulesBar(
                      activeModulo: data.turnoActual?.modulo,
                    ),
                  ],
                ),
                ActiveCallOverlay(
                  turno: activeOverlayTurno,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}