import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'auth_interceptor.dart';
import 'keycloak_service.dart';

class DioFactory {
  static Dio create({
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 20),
    Duration sendTimeout = const Duration(seconds: 10),
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
    ));
    dio.interceptors
        .add(AuthInterceptor(KeycloakService.instance(Env.apiBaseUrl)));

    return dio;
  }

  /// Headers de autenticación para usar en NetworkImage / precacheImage.
  /// Requiere que el token ya esté cacheado (posterior a la primera llamada API).
  static Map<String, String> authHeaders() {
    final token = KeycloakService.instance(Env.apiBaseUrl).syncToken;
    if (token == null) return {};
    return {'Authorization': 'Bearer $token'};
  }
}
