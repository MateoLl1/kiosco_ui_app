import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';

class AutoconsaAuthDatasource extends AuthDatasource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: Env.authBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': Headers.formUrlEncodedContentType,
      },
    ),
  );

  @override
  Future<AuthTokenResponse> getAuthToken() async {
    try {
      final response = await _dio.post(
        '',
        data: {
          'client_id': Env.authClientId,
          'client_secret': Env.authClientSecret,
          'grant_type': Env.authGrantType,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('No se pudo obtener el token');
      }

      return AuthTokenResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      final detalle = e.response?.data?.toString() ?? e.message ?? 'Error de autenticación';
      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error obteniendo token: $e');
    }
  }
}