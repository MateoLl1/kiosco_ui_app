

import 'package:dio/dio.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/infrastructure/infrastructure.dart';

class TurnosAutoconsaDatasource extends TurnosDatasource {


  final _dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));

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