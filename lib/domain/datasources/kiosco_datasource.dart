import 'package:kiosco_au/domain/domain.dart';

abstract class KioscoDatasource {
  Future<List<Agencia>> getAgencias();

  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId);

  Future<List<Cita>> listarCitas(int agenciaId);

  Future<RegistrarLlegadaResponse> registrarLlegada({
    required int agenciaId,
    required int citaId,
  });

  Future<TurnoGeneradoResponse> generarTurnoSinCita({required int agenciaId});

  Future<TurnoGeneradoResponse> generarTurnoSinCitaFlotas({
    required int agenciaId,
  });

  Future<ClienteSiac?> obtenerClientePorIdentificacion({
    required String identificacion,
  });

  Future<TurnoClienteResponse?> obtenerTurnoPorIdentificacion({
    required String identificacion,
    required int agenciaId,
  });

  Future<bool> notificarTurnoWhatsapp ({
    required NotificarTurnoWhatsappRequest request
  });
  
}
