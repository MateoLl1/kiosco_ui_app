import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_ad_states.dart';
import 'package:kiosco_au/presentation/widgets/turnero/turnero_media_cache.dart';

class TurneroImagenSlide extends StatefulWidget {
  final String url;

  const TurneroImagenSlide({super.key, required this.url});

  @override
  State<TurneroImagenSlide> createState() => _TurneroImagenSlideState();
}

class _TurneroImagenSlideState extends State<TurneroImagenSlide> {
  String? _localPath;

  @override
  void initState() {
    super.initState();
    // Chequeo sincrónico para evitar el frame de `waiting` que dispararía
    // Image.network aunque el archivo ya esté en disco.
    _localPath = TurneroMediaCache.getCached(widget.url);
    if (_localPath == null) {
      TurneroMediaCache.get(widget.url).then((path) {
        if (mounted && path != null) setState(() => _localPath = path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_localPath != null) {
      return Image.file(
        File(_localPath!),
        fit: BoxFit.fill,
        errorBuilder: (_, _, _) => TurneroAdError(
          mensaje: 'No se pudo cargar la imagen.',
          detalle: widget.url,
        ),
      );
    }

    // Primera carga: muestra desde red mientras descarga.
    return Image.network(
      widget.url,
      fit: BoxFit.fill,
      errorBuilder: (_, _, _) => TurneroAdError(
        mensaje: 'No se pudo cargar la imagen.',
        detalle: widget.url,
      ),
    );
  }
}
