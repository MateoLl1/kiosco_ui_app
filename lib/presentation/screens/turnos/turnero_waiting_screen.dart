import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
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
  static const String kokoroUrl = 'http://localhost:8880/v1/audio/speech';

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  final AudioPlayer audioPlayer = AudioPlayer();

  DateTime now = DateTime.now();
  String? ultimaLlaveMostrada;
  String? ultimaLlaveAudio;
  Turno? activeOverlayTurno;
  Timer? overlayTimer;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(pantallaTurnosProvider.notifier).loadPantalla();
    });

    _startClock();
  }

  @override
  void dispose() {
    overlayTimer?.cancel();
    audioPlayer.dispose();
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

  String _buildLlaveTurno(Turno turno) {
    final referencia = turno.fechaReferencia?.millisecondsSinceEpoch ?? 0;
    return '${turno.asgCodigo}_$referencia';
  }

  String _limpiarTexto(String valor) {
    return valor.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalizarTurnoParaAudio(String turno) {
    return turno
        .replaceAll('-', ' ')
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  String _crearMensajeAudio(Turno turno) {
    final turnoTexto = _normalizarTurnoParaAudio(turno.turno);
    final nombreCliente = _limpiarTexto(turno.nombreCliente);
    final modulo = _limpiarTexto(turno.modulo);

    return 'Turno $turnoTexto, $nombreCliente, acercarse al módulo $modulo';
  }

  Future<void> _reproducirAudio(Turno turno) async {
    final llaveAudio = _buildLlaveTurno(turno);

    if (ultimaLlaveAudio == llaveAudio) return;

    ultimaLlaveAudio = llaveAudio;

    final mensaje = _crearMensajeAudio(turno);

    final response = await dio.post<List<int>>(
      kokoroUrl,
      data: {
        'model': 'kokoro',
        'voice': 'em_alex',
        'input': mensaje,
        'language': 'es',
        'response_format': 'wav',
        'speed': 0.95,
      },
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    final data = response.data;
    if (data == null || data.isEmpty) return;

    final bytes = Uint8List.fromList(data);

    await audioPlayer.stop();
    await audioPlayer.play(BytesSource(bytes));
  }

  void _handleOverlayTurno(Turno? turnoActual) {
    if (turnoActual == null) return;

    final llaveActual = _buildLlaveTurno(turnoActual);

    if (ultimaLlaveMostrada == llaveActual) return;

    ultimaLlaveMostrada = llaveActual;
    activeOverlayTurno = turnoActual;

    overlayTimer?.cancel();
    overlayTimer = Timer(const Duration(seconds: 8), () {
      if (!mounted) return;
      setState(() {
        activeOverlayTurno = null;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      setState(() {});

      try {
        await _reproducirAudio(turnoActual);
      } catch (_) {}
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