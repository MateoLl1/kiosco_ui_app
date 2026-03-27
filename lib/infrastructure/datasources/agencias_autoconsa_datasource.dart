import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';

class AgenciasAutoconsaDatasource implements AgenciasDatasource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
    ),
  );

  @override
  Future<List<Agencia>> getAgencias() async {
    try {
      final response = await _dio.get('/agencias');
      final List<dynamic> data = response.data;
      final List<Agencia> agencias = data
          .map((json) => AgenciaMapper.agenciaToEntity(json))
          .toList();
      return agencias;
    } on DioException catch (e) {
      print('DioException en getAgencias');
      print('message: ${e.message}');
      print('statusCode: ${e.response?.statusCode}');
      print('responseData: ${e.response?.data}');
      print('path: ${e.requestOptions.path}');
      print('baseUrl: ${e.requestOptions.baseUrl}');
      rethrow;
    } catch (e, stackTrace) {
      print('Error general en getAgencias: $e');
      print(stackTrace);
      rethrow;
    }
  }
}