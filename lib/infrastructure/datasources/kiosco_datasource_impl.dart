

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
  
  @override
  Future<List<Cita>> listarCitas(int agenciaId) async {
    final response = await _dio.get(
      '/turnos/recepcion',
      queryParameters: {
        'agenciaId': agenciaId,
      },
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map((json) => CitaMapper.citaToEntity(json as Map<String, dynamic>))
        .toList();
  }
  
  @override
  Future<RegistrarLlegadaResponse> registrarLlegada({
    required int agenciaId,
    required int citaId,
  }) async {
    final response = await _dio.post(
      '/turnos/recepcion/registrar-llegada',
      data: {
        'agenciaId': agenciaId,
        'citaId': citaId,
      },
    );

    return RegistrarLlegadaResponseMapper.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
  
    @override
  Future<TurnoGeneradoResponse> generarTurnoSinCita({
    required int agenciaId,
  }) async {
    final response = await _dio.post(
      '/turnos/sin-cita',
      queryParameters: {
        'agenciaId': agenciaId,
      },
    );

    return TurnoGeneradoResponseMapper.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<TurnoGeneradoResponse> generarTurnoSinCitaFlotas({
    required int agenciaId,
  }) async {
    final response = await _dio.post(
      '/turnos/sin-cita-flotas',
      queryParameters: {
        'agenciaId': agenciaId,
      },
    );

    return TurnoGeneradoResponseMapper.fromJson(
      response.data as Map<String, dynamic>,
    );
  }




}