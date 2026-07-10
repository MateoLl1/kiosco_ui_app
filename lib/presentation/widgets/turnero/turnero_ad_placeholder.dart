import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_ad_states.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_imagen_slide.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_media_cache.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_video_slide.dart';

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
  final _pageController = PageController();

  Timer? _timer;
  int _paginaActual = 0;
  bool _cargando = true;
  String? _imagenFallbackUrl; // URL de la primera imagen, usada como fallback en videos
  List<TurneroMedia> _publicidad = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void didUpdateWidget(covariant TurneroAdPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cuando agenciaId llega válido después de que la sesión cargó desde storage
    if (oldWidget.agenciaId != widget.agenciaId && widget.agenciaId > 0) {
      _timer?.cancel();
      setState(() {
        _publicidad = [];
        _imagenFallbackUrl = null;
        _cargando = true;
        _paginaActual = 0;
      });
      _cargar();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    if (widget.agenciaId <= 0) {
      if (mounted) setState(() => _cargando = false);
      return;
    }

    try {
      final lista = await ref.read(turneroMediaProvider(widget.agenciaId).future);
      final items = List<TurneroMedia>.from(lista);

      final imagenes = items
          .where((e) => e.tipo.trim().toLowerCase() == 'imagen')
          .toList();

      final fallback = imagenes.isNotEmpty ? imagenes.first.url : null;

      // Si el primero es video, poner una imagen antes para tener fallback visual.
      if (imagenes.isNotEmpty &&
          items.isNotEmpty &&
          items.first.tipo.trim().toLowerCase() == 'video') {
        final primera = imagenes.first;
        items
          ..remove(primera)
          ..insert(0, primera);
      }


      if (!mounted) return;

      setState(() {
        _publicidad = items;
        _imagenFallbackUrl = fallback;
        _cargando = false;
        _paginaActual = 0;
      });

      // Pre-descarga todos los archivos en paralelo para que las siguientes
      // vueltas del slideshow los sirvan desde disco.
      for (final item in items) {
        TurneroMediaCache.get(item.url);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _programarTimer());
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _programarTimer() {
    _timer?.cancel();
    if (_publicidad.length <= 1) return;

    final tipo = _publicidad[_paginaActual].tipo.trim().toLowerCase();
    if (tipo == 'video') return;

    _timer = Timer(const Duration(seconds: 8), _irSiguiente);
  }

  void _irSiguiente() {
    if (!mounted || !_pageController.hasClients || _publicidad.isEmpty) return;
    final next = (_paginaActual + 1) % _publicidad.length;
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _paginaActual = index);
    _programarTimer();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline.withValues(alpha: 0.2)),
        color: colors.surface,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContenido(colors),
    );
  }

  Widget _buildContenido(ColorScheme colors) {
    if (_cargando) return _buildCargando(colors);
    if (_publicidad.isEmpty) return const TurneroAdEmpty();
    return _buildSlideshow();
  }

  Widget _buildCargando(ColorScheme colors) {
    return Center(child: CircularProgressIndicator(color: colors.primary));
  }

  Widget _buildSlideshow() {
    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _publicidad.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (_, index) {
              final item = _publicidad[index];
              if (item.tipo.trim().toLowerCase() == 'video') {
                return TurneroVideoSlide(
                  key: ValueKey(item.url),
                  url: item.url,
                  imagenFallbackUrl: _imagenFallbackUrl,
                  onFinalizado: _irSiguiente,
                );
              }
              return TurneroImagenSlide(
                key: ValueKey(item.url),
                url: item.url,
              );
            },
          ),
        ),
        if (_publicidad.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: _Dots(total: _publicidad.length, activo: _paginaActual),
          ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int total;
  final int activo;

  const _Dots({required this.total, required this.activo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: activo == i ? 24 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: activo == i
                ? colors.primary
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
