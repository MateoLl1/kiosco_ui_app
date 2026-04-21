


import 'package:kiosco_au/domain/domain.dart';

class KioscoRepositoryImpl extends KioscoRepository {
  
  final KioscoDatasource datasource;

  KioscoRepositoryImpl({required  this.datasource});
  
  
  @override
  Future<List<Agencia>> getAgencias() {
    return datasource.getAgencias();
  }

  @override
  Future<PantallaTurnosResponse> getPantallaTurnos(int agenciaId) {
    return datasource.getPantallaTurnos(agenciaId);
  }
  
  @override
  Future<List<Cita>> listarCitas(int agenciaId) {
    return datasource.listarCitas(agenciaId); 
  }
  
  @override
  Future<RegistrarLlegadaResponse> registrarLlegada({required int agenciaId, required int citaId}) {
    return datasource.registrarLlegada(agenciaId: agenciaId, citaId: citaId);
  }
  
  @override
  Future<TurnoGeneradoResponse> generarTurnoSinCita({required int agenciaId}) {
    return datasource.generarTurnoSinCita(agenciaId: agenciaId);
  }
  
  @override
  Future<TurnoGeneradoResponse> generarTurnoSinCitaFlotas({required int agenciaId}) {
    return datasource.generarTurnoSinCita(agenciaId: agenciaId);
  }
  
}