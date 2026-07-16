import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/infrastructure/http/keycloak_service.dart';
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

  // Memoizado en initState para que FutureBuilder no relance la petición en cada rebuild.
  late final Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = KeycloakService.instance(Env.apiBaseUrl).getToken();
    _localPath = TurneroMediaCache.getCached(widget.url);
    if (_localPath == null) {
      // Descarga al disco en background — cuando termine actualiza a Image.file.
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
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _buildDesdeRed(),
      );
    }
    return _buildDesdeRed();
  }

  /// Muestra la imagen directo desde la red con el token de auth.
  /// Se usa mientras la descarga a disco está en curso o si falla.
  Widget _buildDesdeRed() {
    return FutureBuilder<String?>(
      future: _tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final token = snapshot.data;
        if (token == null) {
          return TurneroAdError(
            mensaje: 'No se pudo autenticar.',
            detalle: widget.url,
          );
        }
        return Image.network(
          widget.url,
          headers: {'Authorization': 'Bearer $token'},
          fit: BoxFit.fill,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, _, _) => TurneroAdError(
            mensaje: 'No se pudo cargar la imagen.',
            detalle: widget.url,
          ),
        );
      },
    );
  }
}
