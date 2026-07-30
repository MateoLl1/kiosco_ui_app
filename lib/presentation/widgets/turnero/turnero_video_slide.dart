import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/infrastructure/http/keycloak_service.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_ad_states.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_media_cache.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class TurneroVideoSlide extends StatefulWidget {
  final String url;
  final String? imagenFallbackUrl;

  /// True solo cuando este slide es la página visible del PageView.
  /// PageView construye las páginas vecinas, así que sin esto el video
  /// arrancaría fuera de pantalla y se reproduciría dos veces.
  final bool activo;

  final VoidCallback onFinalizado;

  const TurneroVideoSlide({
    super.key,
    required this.url,
    required this.imagenFallbackUrl,
    required this.activo,
    required this.onFinalizado,
  });

  @override
  State<TurneroVideoSlide> createState() => _TurneroVideoSlideState();
}

class _TurneroVideoSlideState extends State<TurneroVideoSlide> {
  late final Player _player;
  late final VideoController _controller;

  StreamSubscription<bool>? _completedSub;
  StreamSubscription<String>? _errorSub;

  Timer? _timeoutTimer;
  Timer? _avanceTimer;

  bool _cargando = true;
  bool _error = false;
  String _errorTexto = '';

  /// Media abierta y primer frame decodificado, listo para reproducir.
  bool _preparado = false;

  /// Reproducción en curso — evita arrancar dos veces y filtra el evento
  /// `completed` de un slide que no está al aire.
  bool _reproduciendo = false;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _controller = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: false,
      ),
    );
    _prepararVideo();
  }

  @override
  void didUpdateWidget(TurneroVideoSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activo && !oldWidget.activo) {
      _arrancar();
    } else if (!widget.activo && oldWidget.activo) {
      _detener();
    }
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _avanceTimer?.cancel();
    _completedSub?.cancel();
    _errorSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _prepararVideo() async {
    _timeoutTimer = Timer(const Duration(seconds: 60), _onTimeout);

    _completedSub = _player.stream.completed.listen((done) {
      // Solo avanza el carrusel si este slide es el que está al aire y
      // efectivamente estaba reproduciendo.
      if (done && widget.activo && _reproduciendo) {
        _reproduciendo = false;
        widget.onFinalizado();
      }
    });

    _errorSub = _player.stream.error.listen(_onPlayerError);

    try {
      if (Platform.isAndroid) {
        final native = _player.platform;
        if (native is NativePlayer) {
          await native.setProperty('hwdec', 'no');
          await native.setProperty('vd-lavc-threads', '4');
          // Salta el filtro de deblocking: baja bastante el costo de decodificar
          // HEVC por software, a cambio de algo de bloqueo en la imagen. Sin
          // esto el CPU de 32 bits no llega a 24 fps y arranca a tirones.
          await native.setProperty('vd-lavc-skiploopfilter', 'all');
          // Sin audio: la publicidad va muteada, pero mpv seguía decodificando
          // la pista y usándola como reloj maestro (video-sync=audio). Con un
          // decoder de video ajustado eso forzaba descarte de frames al inicio.
          // Además evita el setup de AudioTrack/OpenSLES en cada slide.
          await native.setProperty('audio', 'no');
        }
      }

      await _player.setVolume(0);

      // Obtiene token para httpHeaders (streaming fallback con auth).
      final token = await KeycloakService.instance(Env.apiBaseUrl).getToken();

      final localPath = await TurneroMediaCache.get(widget.url);

      final Media media;
      if (localPath != null) {
        media = Media('file://$localPath');
      } else if (token != null) {
        // Descarga falló — intentar streaming directo con auth.
        media = Media(widget.url, httpHeaders: {'Authorization': 'Bearer $token'});
      } else {
        _timeoutTimer?.cancel();
        _mostrarError('No se pudo autenticar para cargar el video.');
        return;
      }

      // Abre en pausa: decodifica el primer frame y deja el decoder caliente
      // sin que corra el reloj de reproducción. Cuando el slide entra al aire
      // arranca ya listo, en vez de en frío.
      await _player.open(media, play: false);

      _timeoutTimer?.cancel();
      if (!mounted) return;
      _preparado = true;

      if (widget.activo) {
        await _arrancar();
      }
    } catch (e) {
      _timeoutTimer?.cancel();
      _mostrarError(e.toString());
    }
  }

  Future<void> _arrancar() async {
    if (!_preparado || _reproduciendo || _error) return;
    _reproduciendo = true;
    try {
      await _player.seek(Duration.zero);
      await _player.play();
      if (mounted) setState(() => _cargando = false);
    } catch (e) {
      _reproduciendo = false;
      _mostrarError(e.toString());
    }
  }

  Future<void> _detener() async {
    if (!_reproduciendo) return;
    _reproduciendo = false;
    try {
      await _player.pause();
      await _player.seek(Duration.zero);
    } catch (_) {}
    if (mounted) setState(() => _cargando = true);
  }

  void _onTimeout() {
    if (!mounted) return;
    _mostrarError('Tiempo agotado cargando el video.');
  }

  void _onPlayerError(String value) {
    final texto = value.toLowerCase();
    if (texto.contains('avhwdevicecontext') ||
        texto.contains('hardware') ||
        texto.contains('hwdevice')) {
      return;
    }
    if (mounted) _mostrarError(value);
  }

  void _mostrarError(String texto) {
    if (!mounted) return;
    setState(() {
      _error = true;
      _cargando = false;
      _errorTexto = texto;
    });
    _avanceTimer?.cancel();
    _avanceTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) widget.onFinalizado();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return TurneroAdError(
        mensaje: 'No se pudo cargar el video.',
        detalle: _errorTexto.isEmpty ? widget.url : _errorTexto,
      );
    }

    if (_cargando) {
      final fallback = widget.imagenFallbackUrl;
      if (fallback != null && fallback.trim().isNotEmpty) {
        final localFallback = TurneroMediaCache.getCached(fallback);
        if (localFallback != null) {
          return Image.file(File(localFallback), fit: BoxFit.fill);
        }
        // Token ya cacheado a esta altura (se usó antes para cargar la lista).
        final token = KeycloakService.instance(Env.apiBaseUrl).syncToken;
        if (token != null) {
          return Image.network(
            fallback,
            headers: {'Authorization': 'Bearer $token'},
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => TurneroAdLoadingVideo(url: widget.url),
          );
        }
      }
      return TurneroAdLoadingVideo(url: widget.url);
    }

    return Video(controller: _controller, fit: BoxFit.fill);
  }
}
