

import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';

class KioscoDatasourceImpl extends KioscoDatasource {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  @override
  Future<List<Agencia>> getAgencias() async {
    final response = await _dio.get('/agencias');
    final List<dynamic> data = response.data;
    final List<Agencia> agencias = data
        .map((json) => AgenciaMapper.agenciaToEntity(json))
        .toList();
    return agencias;
  }

  @override
  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId) async {
    final response = await _dio.get(
      '/PantallaTurnos',
      queryParameters: {
        'agenciaId': agenciaId,
      },
    );

    return PantallaTurnosMapper.fromJson(response.data as Map<String, dynamic>);
  }
}