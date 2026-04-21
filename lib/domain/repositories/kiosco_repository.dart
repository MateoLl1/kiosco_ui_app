




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
  });

  Future<TurnoGeneradoResponse> generarTurnoSinCitaFlotas({
    required int agenciaId,
  });
}