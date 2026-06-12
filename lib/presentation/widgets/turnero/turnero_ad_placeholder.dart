import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class TurneroAdPlaceholder extends ConsumerStatefulWidget {
  final int agenciaId;
  final List<Turno> recienLlamados;

  const TurneroAdPlaceholder({
    super.key,
    required this.agenciaId,
    required this.recienLlamados,
  });

  @override
  ConsumerState<TurneroAdPlaceholder> createState() =>
      _TurneroAdPlaceholderState();
}

class _TurneroAdPlaceholderState extends ConsumerState<TurneroAdPlaceholder> {
  final PageController pageController = PageController();

  Timer? timerPublicidad;

  int paginaActual = 0;
  bool cargando = true;

  String? imagenFallbackUrl;

  List<TurneroMedia> publicidad = [];

  @override
  void initState() {
    super.initState();
    _cargarPublicidadUnaSolaVez();
  }

  @override
  void dispose() {
    timerPublicidad?.cancel();
    pageController.dispose();
    super.dispose();
  }

  Future<void> _cargarPublicidadUnaSolaVez() async {
    if (widget.agenciaId <= 0) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        publicidad = [];
        imagenFallbackUrl = null;
      });

      return;
    }

    try {
      final lista = await ref
          .read(kioscoRepositoryProvider)
          .getTurneroMediaPorAgencia(agenciaId: widget.agenciaId);

      final filtrada = lista.where((item) {
        final tipo = item.tipo.trim().toLowerCase();
        final url = item.url.trim();

        return url.isNotEmpty && (tipo == 'imagen' || tipo == 'video');
      }).toList();

      filtrada.sort((a, b) {
        final ordenA = a.orden ?? 0;
        final ordenB = b.orden ?? 0;

        final compararOrden = ordenA.compareTo(ordenB);
        if (compararOrden != 0) return compararOrden;

        return a.codigo.compareTo(b.codigo);
      });

      final imagenes = filtrada.where((item) {
        return item.tipo.trim().toLowerCase() == 'imagen' &&
            item.url.trim().isNotEmpty;
      }).toList();

      final imagenFallback = imagenes.isNotEmpty ? imagenes.first.url : null;

      if (imagenes.isNotEmpty &&
          filtrada.isNotEmpty &&
          filtrada.first.tipo.trim().toLowerCase() == 'video') {
        final primeraImagen = imagenes.first;
        filtrada.remove(primeraImagen);
        filtrada.insert(0, primeraImagen);
      }

      if (imagenFallback != null && mounted) {
        try {
          await precacheImage(
            NetworkImage(imagenFallback),
            context,
          ).timeout(const Duration(seconds: 3));
        } catch (_) {}
      }

      debugPrint(
        'PUBLICIDAD AGENCIA ${widget.agenciaId}: ${filtrada.length} objetos',
      );

      for (final item in filtrada) {
        debugPrint('MEDIA ${item.codigo} | ${item.tipo} | ${item.url}');
      }

      if (!mounted) return;

      setState(() {
        publicidad = filtrada;
        imagenFallbackUrl = imagenFallback;
        cargando = false;
        paginaActual = 0;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _programarPaginaActual();
      });
    } catch (e, st) {
      debugPrint('ERROR CARGANDO PUBLICIDAD: $e');
      debugPrint(st.toString());

      if (!mounted) return;

      setState(() {
        publicidad = [];
        imagenFallbackUrl = null;
        cargando = false;
      });
    }
  }

  void _programarPaginaActual() {
    timerPublicidad?.cancel();

    if (publicidad.length <= 1) return;

    final itemActual = publicidad[paginaActual];
    final tipo = itemActual.tipo.trim().toLowerCase();

    if (tipo == 'video') return;

    timerPublicidad = Timer(const Duration(seconds: 8), () {
      _irSiguiente();
    });
  }

  void _irSiguiente() {
    if (!mounted || !pageController.hasClients || publicidad.isEmpty) return;

    final siguientePagina =
        paginaActual + 1 >= publicidad.length ? 0 : paginaActual + 1;

    pageController.animateToPage(
      siguientePagina,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      paginaActual = index;
    });

    _programarPaginaActual();
  }

  void _onVideoFinalizado() {
    _irSiguiente();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.2),
        ),
        color: colors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: cargando
          ? imagenFallbackUrl != null && imagenFallbackUrl!.trim().isNotEmpty
              ? Image.network(
                  imagenFallbackUrl!,
                  fit: BoxFit.fill,
                  errorBuilder: (_, _, _) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: colors.primary,
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: colors.primary,
                  ),
                )
          : publicidad.isEmpty
              ? _TurneroAdEmpty(colors: colors)
              : Stack(
                  children: [
                    Positioned.fill(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: publicidad.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final item = publicidad[index];
                          final tipo = item.tipo.trim().toLowerCase();

                          if (tipo == 'video') {
                            return _TurneroVideoSlide(
                              key: ValueKey(item.url),
                              url: item.url,
                              imagenFallbackUrl: imagenFallbackUrl,
                              onFinalizado: _onVideoFinalizado,
                            );
                          }

                          return _TurneroImagenSlide(
                            key: ValueKey(item.url),
                            url: item.url,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 18,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          publicidad.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: paginaActual == index ? 24 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: paginaActual == index
                                  ? colors.primary
                                  : Colors.white.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class _TurneroImagenSlide extends StatelessWidget {
  final String url;

  const _TurneroImagenSlide({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Image.network(
      url,
      fit: BoxFit.fill,
      errorBuilder: (_, error, stackTrace) {
        debugPrint('ERROR IMAGEN PUBLICIDAD: $error');
        debugPrint(url);

        return _TurneroAdError(
          colors: colors,
          mensaje: 'No se pudo cargar la imagen publicitaria.',
          detalle: url,
        );
      },
    );
  }
}

class _TurneroVideoSlide extends StatefulWidget {
  final String url;
  final String? imagenFallbackUrl;
  final VoidCallback onFinalizado;

  const _TurneroVideoSlide({
    super.key,
    required this.url,
    required this.imagenFallbackUrl,
    required this.onFinalizado,
  });

  @override
  State<_TurneroVideoSlide> createState() => _TurneroVideoSlideState();
}

class _TurneroVideoSlideState extends State<_TurneroVideoSlide> {
  late final Player player;
  late final VideoController controller;

  StreamSubscription<bool>? completedSubscription;
  StreamSubscription<String>? errorSubscription;

  Timer? timerTimeout;
  Timer? timerErrorAvance;

  bool cargando = true;
  bool error = false;
  String errorTexto = '';

  @override
  void initState() {
    super.initState();

    player = Player();

    controller = VideoController(
      player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: false,
      ),
    );

    _iniciarVideo();
  }

  @override
  void dispose() {
    timerTimeout?.cancel();
    timerErrorAvance?.cancel();
    completedSubscription?.cancel();
    errorSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  Future<void> _iniciarVideo() async {
    debugPrint('INICIANDO VIDEO PUBLICIDAD: ${widget.url}');

    timerTimeout = Timer(const Duration(seconds: 20), () {
      if (!mounted) return;

      debugPrint('TIMEOUT VIDEO PUBLICIDAD: ${widget.url}');

      setState(() {
        error = true;
        cargando = false;
        errorTexto = 'Tiempo agotado cargando el video.';
      });

      timerErrorAvance?.cancel();
      timerErrorAvance = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        widget.onFinalizado();
      });
    });

    completedSubscription = player.stream.completed.listen((completed) {
      if (completed) {
        widget.onFinalizado();
      }
    });

    errorSubscription = player.stream.error.listen((value) {
      debugPrint('ERROR MEDIA_KIT VIDEO: $value');

      final texto = value.toLowerCase();

      if (texto.contains('avhwdevicecontext') ||
          texto.contains('hardware') ||
          texto.contains('hwdevice')) {
        debugPrint('ERROR DE HARDWARE IGNORADO, SE CONTINÚA CON SOFTWARE.');
        return;
      }

      if (!mounted) return;

      setState(() {
        error = true;
        cargando = false;
        errorTexto = value;
      });

      timerErrorAvance?.cancel();
      timerErrorAvance = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        widget.onFinalizado();
      });
    });

    try {
      await player.setVolume(0);
      await player.open(Media(widget.url), play: true);

      await Future.delayed(const Duration(milliseconds: 800));

      timerTimeout?.cancel();

      if (!mounted) return;

      setState(() {
        cargando = false;
      });
    } catch (e, st) {
      timerTimeout?.cancel();

      debugPrint('ERROR ABRIENDO VIDEO: $e');
      debugPrint(st.toString());
      debugPrint(widget.url);

      if (!mounted) return;

      setState(() {
        error = true;
        cargando = false;
        errorTexto = e.toString();
      });

      timerErrorAvance?.cancel();
      timerErrorAvance = Timer(const Duration(seconds: 5), () {
        if (!mounted) return;
        widget.onFinalizado();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (error) {
      return _TurneroAdError(
        colors: colors,
        mensaje: 'No se pudo cargar el video publicitario.',
        detalle: errorTexto.isEmpty ? widget.url : errorTexto,
      );
    }

    if (cargando) {
      final fallback = widget.imagenFallbackUrl;

      if (fallback != null && fallback.trim().isNotEmpty) {
        return Image.network(
          fallback,
          fit: BoxFit.fill,
          errorBuilder: (_, _, _) {
            return _TurneroAdLoadingVideo(
              colors: colors,
              url: widget.url,
            );
          },
        );
      }

      return _TurneroAdLoadingVideo(
        colors: colors,
        url: widget.url,
      );
    }

    return Video(
      controller: controller,
      fit: BoxFit.fill,
    );
  }
}

class _TurneroAdLoadingVideo extends StatelessWidget {
  final ColorScheme colors;
  final String url;

  const _TurneroAdLoadingVideo({
    required this.colors,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surface,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          CircularProgressIndicator(
            color: colors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando video publicitario...',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            url,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.7),
              fontSize: 13,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TurneroAdEmpty extends StatelessWidget {
  final ColorScheme colors;

  const _TurneroAdEmpty({
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surface,
            colors.primary.withValues(alpha: 0.08),
            colors.secondary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'ESPACIO PUBLICITARIO',
              style: TextStyle(
                color: colors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aquí puedes mostrar campañas,\nimágenes o videos mientras\nlos clientes esperan.',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 30,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No hay archivos configurados para esta agencia.',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _TurneroAdError extends StatelessWidget {
  final ColorScheme colors;
  final String mensaje;
  final String detalle;

  const _TurneroAdError({
    required this.colors,
    required this.mensaje,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surface,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            'ESPACIO PUBLICITARIO',
            style: TextStyle(
              color: colors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mensaje,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 30,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            detalle,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}