import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:kiosco_au/infrastructure/http/dio_factory.dart';

/// Cache de sesión para archivos de media descargados al directorio temporal.
/// Compartida entre todas las instancias — la primera descarga, el resto lee de disco.
class TurneroMediaCache {
  TurneroMediaCache._();

  static final _dio = DioFactory.create(
    receiveTimeout: const Duration(minutes: 5),
  );
  static final Map<String, String> _paths = {};
  static final Map<String, Future<String?>> _pending = {};

  /// Retorna la ruta local si ya fue descargado, null si aún no.
  static String? getCached(String url) => _paths[url];

  static Future<String?> get(String url) {
    if (_paths.containsKey(url)) return Future.value(_paths[url]);
    return _pending.putIfAbsent(
      url,
      () => _download(url).whenComplete(() => _pending.remove(url)),
    );
  }

  /// Borra del directorio temporal los archivos `turnero_*` que no
  /// correspondan a las URLs vigentes (publicidad que ya no está configurada)
  /// y cualquier `.tmp` huérfano de descargas interrumpidas.
  static Future<void> prune(Iterable<String> urlsVigentes) async {
    try {
      final dir = await getTemporaryDirectory();
      final vigentes = urlsVigentes.map(_fileName).toSet();

      await for (final entry in dir.list()) {
        if (entry is! File) continue;
        final nombre = entry.uri.pathSegments.last;
        if (!nombre.startsWith('turnero_')) continue;
        if (nombre.endsWith('.tmp') || !vigentes.contains(nombre)) {
          try {
            await entry.delete();
          } catch (_) {}
        }
      }
    } catch (_) {
      // La limpieza nunca debe afectar al slideshow.
    }
  }

  static Future<String?> _download(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${_fileName(url)}');
      if (!await file.exists()) {
        // Descarga a un temporal y renombra al final: si la app se cierra o
        // la red se corta a mitad de descarga no queda un archivo truncado
        // que `exists()` daría por válido para siempre.
        final tmp = File('${file.path}.tmp');
        await _dio.download(url, tmp.path);
        await tmp.rename(file.path);
      }
      _paths[url] = file.path;
      return file.path;
    } catch (_) {
      return null;
    }
  }

  static String _fileName(String url) {
    final ext = url.toLowerCase().contains('.mp4') ? 'mp4' : 'jpg';
    return 'turnero_${_hashEstable(url)}.$ext';
  }

  /// FNV-1a de 64 bits. `String.hashCode` no está garantizado entre versiones
  /// de Dart: un upgrade de Flutter invalidaría toda la caché y dejaría los
  /// archivos viejos huérfanos. Este hash es determinista para siempre.
  static String _hashEstable(String texto) {
    var hash = 0xcbf29ce484222325;
    for (final unidad in texto.codeUnits) {
      hash ^= unidad;
      hash *= 0x100000001b3;
    }
    return (hash & 0x7fffffffffffffff).toRadixString(16);
  }
}
