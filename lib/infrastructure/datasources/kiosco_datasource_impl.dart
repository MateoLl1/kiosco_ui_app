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
      queryParameters: {'agenciaId': agenciaId},
    );

    return PantallaTurnosMapper.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<List<Cita>> listarCitas(int agenciaId) async {
    final response = await _dio.get(
      '/turnos/recepcion',
      queryParameters: {'agenciaId': agenciaId},
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
      data: {'agenciaId': agenciaId, 'citaId': citaId},
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
      queryParameters: {'agenciaId': agenciaId},
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
      queryParameters: {'agenciaId': agenciaId},
    );

    return TurnoGeneradoResponseMapper.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ClienteSiac?> obtenerClientePorIdentificacion({
    required String identificacion,
    required int agenciaId,
  }) async {
    try {
      final response = await _dio.get(
        '/cliente/por-identificacion',
        queryParameters: {
          'identificacion': identificacion,
          'agenciaId': agenciaId,
        },
      );

      if (response.statusCode != 200 || response.data == null) {
        throw Exception('No se pudo consultar el cliente');
      }

      return ClienteSiac.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      final detalle =
          e.response?.data?.toString() ??
          e.message ??
          'Error consultando cliente';
      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error consultando cliente: $e');
    }
  }

  @override
  Future<TurnoClienteResponse?> obtenerTurnoPorIdentificacion({
    required String identificacion,
    required int agenciaId,
  }) async {
    try {
      final response = await _dio.get(
        '/turnos/por-identificacion',
        queryParameters: {
          'identificacion': identificacion,
          'agenciaId': agenciaId,
        },
      );

      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      return TurnoClienteResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }

      final detalle =
          e.response?.data?.toString() ??
          e.message ??
          'Error consultando turno';

      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error consultando turno: $e');
    }
  }

  @override
  Future<bool> notificarTurnoWhatsapp({
    required NotificarTurnoWhatsappRequest request,
  }) async {
    try {
      final response = await _dio.post(
        '/whatsapp/turno',
        data: request.toJson(),
      );

      return response.statusCode == 200;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<TurneroMedia>> getTurneroMediaPorAgencia({
    required int agenciaId,
  }) async {
    final response = await _dio.get(
      '/TurneroMedia/agencia/$agenciaId',
      queryParameters: {'estado': 'A'},
    );

    final data = response.data;

    if (data is! List) return [];

    return data
        .map((item) => TurneroMedia.fromJson(item as Map<String, dynamic>))
        .where((item) => item.url.trim().isNotEmpty)
        .toList()
      ..sort((a, b) => (a.orden ?? 0).compareTo(b.orden ?? 0));
  }

  @override
  Future<TurnoAtencionResponse?> llamarSiguienteTurno({
    required int agenciaId,
  }) async {
    try {
      final response = await _dio.post(
        '/turnos/llamar-siguiente',
        queryParameters: {'agenciaId': agenciaId},
      );

      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      return TurnoAtencionResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }

      final detalle =
          e.response?.data?.toString() ??
          e.message ??
          'Error llamando siguiente turno';

      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error llamando siguiente turno: $e');
    }
  }

  @override
  Future<TurnoAtencionResponse?> rellamarTurno({required int asgCodigo}) async {
    try {
      final response = await _dio.post('/turnos/$asgCodigo/rellamar');

      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      return TurnoAtencionResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }

      final detalle =
          e.response?.data?.toString() ?? e.message ?? 'Error rellamando turno';

      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error rellamando turno: $e');
    }
  }

  @override
  Future<TurnoAtencionResponse?> atenderTurno({required int asgCodigo}) async {
    try {
      final response = await _dio.post('/turnos/$asgCodigo/atender');

      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      return TurnoAtencionResponse.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }

      final detalle =
          e.response?.data?.toString() ?? e.message ?? 'Error atendiendo turno';

      throw Exception(detalle);
    } catch (e) {
      throw Exception('Error atendiendo turno: $e');
    }
  }
}
