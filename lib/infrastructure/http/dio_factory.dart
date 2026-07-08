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
}
