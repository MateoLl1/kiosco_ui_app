import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/config/config.dart';
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
  final Dio _ttsDio = Dio(
    BaseOptions(
      connectTimeout: AppDurations.connectTimeout,
      receiveTimeout: AppDurations.ttsReceiveTimeout,
      sendTimeout: AppDurations.sendTimeout,
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    Future.microtask(() async {
      ref.read(pantallaTurnosProvider.notifier).loadPantalla();
    });

    _startClock();
  }

  @override
  void dispose() {
    overlayTimer?.cancel();
    audioPlayer.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

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

    final response = await _ttsDio.post<List<int>>(
      Env.ttsUrl,
      data: {
        'text': mensaje,
        'voice': Env.ttsVoice,
        'rate': Env.ttsRate,
        'pitch': Env.ttsPitch,
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

  Widget _buildContenido({
    required int agenciaId,
    required double sidebarWidth,
    required List<Turno> recienLlamados,
    required List<Turno> pendientes,
    required Turno? turnoActual,
  }) {
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
                      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                      child: TurneroAdPlaceholder(
                        recienLlamados: recienLlamados,
                        agenciaId: agenciaId,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sidebarWidth,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 0, 12),
                      child: TurnosSidebar(
                        turnoActual: turnoActual,
                        pendientes: pendientes,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ActiveCallOverlay(
          turno: activeOverlayTurno,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pantallaTurnosProvider);
    final session = ref.watch(appSessionProvider);
    final agenciaId = session?.agenciaId ?? 0;
    final colors = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final sidebarWidth = width < 900 ? 280.0 : 340.0;
    final dataAnterior = state.asData?.value;

    if (dataAnterior != null) {
      _handleOverlayTurno(dataAnterior.turnoActual);
    }

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: dataAnterior != null
            ? _buildContenido(
                agenciaId: agenciaId,
                sidebarWidth: sidebarWidth,
                recienLlamados: dataAnterior.turnosRecienLlamados,
                pendientes: dataAnterior.turnosPendientes,
                turnoActual: dataAnterior.turnoActual,
              )
            : state.hasError
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                  )
                : _buildContenido(
                    agenciaId: agenciaId,
                    sidebarWidth: sidebarWidth,
                    recienLlamados: const <Turno>[],
                    pendientes: const <Turno>[],
                    turnoActual: null,
                  ),
      ),
    );
  }
}