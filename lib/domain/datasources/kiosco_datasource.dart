


import 'package:kiosco_au/domain/domain.dart';

abstract class KioscoDatasource {
  Future<List<Agencia>> getAgencias();
  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId);
  Future<List<Cita>> listarCitas(int agenciaId);
  Future<RegistrarLlegadaResponse> registrarLlegada({
    required int agenciaId,
    required int citaId,
  });
}