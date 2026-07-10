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

  static Future<String?> _download(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final ext = url.toLowerCase().contains('.mp4') ? 'mp4' : 'jpg';
      final file = File('${dir.path}/turnero_${url.hashCode.abs()}.$ext');
      if (!await file.exists()) {
        await _dio.download(url, file.path);
      }
      _paths[url] = file.path;
      return file.path;
    } catch (_) {
      return null;
    }
  }
}
