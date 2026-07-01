import 'package:kiosco_au/domain/domain.dart';

class KioscoRepositoryImpl extends KioscoRepository {
  final KioscoDatasource datasource;

  KioscoRepositoryImpl({required this.datasource});

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
  Future<RegistrarLlegadaResponse> registrarLlegada({
    required int agenciaId,
    required int citaId,
  }) {
    return datasource.registrarLlegada(agenciaId: agenciaId, citaId: citaId);
  }

  @override
  Future<TurnoGeneradoResponse> generarTurnoSinCita({required int agenciaId}) {
    return datasource.generarTurnoSinCita(agenciaId: agenciaId);
  }

  @override
  Future<TurnoGeneradoResponse> generarTurnoSinCitaFlotas({
    required int agenciaId,
  }) {
    return datasource.generarTurnoSinCitaFlotas(agenciaId: agenciaId);
  }

  @override
  Future<ClienteSiac?> obtenerClientePorIdentificacion({
    required String identificacion,
    required int agenciaId,
  }) {
    return datasource.obtenerClientePorIdentificacion(
      identificacion: identificacion,
      agenciaId: agenciaId
    );
  }

  @override
  Future<TurnoClienteResponse?> obtenerTurnoPorIdentificacion({
    required String identificacion,
    required int agenciaId,
  }) {
    return datasource.obtenerTurnoPorIdentificacion(
      identificacion: identificacion,
      agenciaId: agenciaId,
    );
  }


  @override
  Future<bool> notificarTurnoWhatsapp({
    required NotificarTurnoWhatsappRequest request,
  }) {
    return datasource.notificarTurnoWhatsapp(request: request);
  }

  @override
  Future<List<TurneroMedia>> getTurneroMediaPorAgencia({
    required int agenciaId,
  }){
    return datasource.getTurneroMediaPorAgencia(agenciaId: agenciaId);
  }
  
  @override
  Future<TurnoAtencionResponse?> llamarSiguienteTurno({required int agenciaId}) {
    return datasource.llamarSiguienteTurno(agenciaId: agenciaId);
  }
  
  @override
  Future<TurnoAtencionResponse?> rellamarTurno({required int asgCodigo}) {
    return datasource.rellamarTurno(asgCodigo: asgCodigo);
  }
  
  @override
  Future<TurnoAtencionResponse?> atenderTurno({required int asgCodigo}) {
    return datasource.atenderTurno(asgCodigo: asgCodigo);
  }

  @override
  Future<bool> verificarMostradorHabilitado({required int agenciaId}) {
    return datasource.verificarMostradorHabilitado(agenciaId: agenciaId);
  }

  @override
  Future<TurnoGeneradoResponse> generarTurnoMostrador({
    required int agenciaId,
    String? identificacion,
  }) {
    return datasource.generarTurnoMostrador(
      agenciaId: agenciaId,
      identificacion: identificacion,
    );
  }
}
