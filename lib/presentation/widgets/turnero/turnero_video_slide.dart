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
  final VoidCallback onFinalizado;

  const TurneroVideoSlide({
    super.key,
    required this.url,
    required this.imagenFallbackUrl,
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
    _iniciarVideo();
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

  Future<void> _iniciarVideo() async {
    _timeoutTimer = Timer(const Duration(seconds: 60), _onTimeout);

    _completedSub = _player.stream.completed.listen((done) {
      if (done) widget.onFinalizado();
    });

    _errorSub = _player.stream.error.listen(_onPlayerError);

    try {
      if (Platform.isAndroid) {
        final native = _player.platform;
        if (native is NativePlayer) {
          await native.setProperty('hwdec', 'no');
          await native.setProperty('vd-lavc-threads', '4');
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

      await _player.open(media, play: true);

      await Future.delayed(const Duration(milliseconds: 800));

      _timeoutTimer?.cancel();
      if (mounted) setState(() => _cargando = false);
    } catch (e) {
      _timeoutTimer?.cancel();
      _mostrarError(e.toString());
    }
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
            fit: BoxFit.fill,
            errorBuilder: (_, _, _) => TurneroAdLoadingVideo(url: widget.url),
          );
        }
      }
      return TurneroAdLoadingVideo(url: widget.url);
    }

    return Video(controller: _controller, fit: BoxFit.fill);
  }
}
