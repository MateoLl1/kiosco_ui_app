

import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';

class DataBookDatasource extends InfoCreditoDatasource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Env.autoconsaApiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  Future<Databook> getPerfilDatabook({
    required String token,
    required String identificacion,
    required int empresa,
  }) async {
    try {
      final response = await _dio.get(
        '/perfil-databook',
        queryParameters: {
          'identificacion': identificacion,
          'empresa': empresa,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('No se pudo consultar perfil databook');
      }

      final data = response.data;

      if (data is! List || data.isEmpty) {
        throw Exception('No se encontró información de databook');
      }

      final item = Map<String, dynamic>.from(data.first);

      return Databook.fromJson(item);
    } on DioException catch (e) {
      final detalle =
          e.response?.data?.toString() ?? e.message ?? 'Error consultando databook';
      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error consultando perfil databook: $e');
    }
  }
}