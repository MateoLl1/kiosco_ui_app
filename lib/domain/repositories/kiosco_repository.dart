import 'package:kiosco_au/domain/domain.dart';

abstract class KioscoRepository {
  Future<List<Agencia>> getAgencias();

  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId);

  Future<List<Cita>> listarCitas(int agenciaId);

  Future<RegistrarLlegadaResponse> registrarLlegada({
    required int agenciaId,
    required int citaId,
  });

  Future<TurnoGeneradoResponse> generarTurnoSinCita({
    required int agenciaId,
    String? identificacion,
  });

  Future<TurnoGeneradoResponse> generarTurnoSinCitaFlotas({
    required int agenciaId,
    String? identificacion,
  });

  Future<ClienteSiac?> obtenerClientePorIdentificacion({
    required String identificacion,
    required int agenciaId,
  });

  Future<TurnoClienteResponse?> obtenerTurnoPorIdentificacion({
    required String identificacion,
    required int agenciaId,
  });


  Future<bool> notificarTurnoWhatsapp ({
    required NotificarTurnoWhatsappRequest request
  });

  Future<List<TurneroMedia>> getTurneroMediaPorAgencia({
    required int agenciaId,
  });

  Future<TurnoAtencionResponse?> llamarSiguienteTurno({
    required int agenciaId,
  });

  Future<TurnoAtencionResponse?> rellamarTurno({
    required int asgCodigo,
  });

  Future<TurnoAtencionResponse?> atenderTurno({
    required int asgCodigo,
  });

  Future<bool> verificarMostradorHabilitado({required int agenciaId});

  Future<TurnoGeneradoResponse> generarTurnoMostrador({
    required int agenciaId,
    String? identificacion,
  });
}
