class TurnoGeneradoResponse {
  final double asgCodigo;
  final String turno;
  final String tipo;
  final String area;
  final String estado;
  final String modulo;
  final double agenciaId;
  final int personasPorDelante;
  final int tiempoEstimadoMinutos;
  final DateTime fecha;

  TurnoGeneradoResponse({
    required this.asgCodigo,
    required this.turno,
    required this.tipo,
    required this.area,
    required this.estado,
    required this.modulo,
    required this.agenciaId,
    required this.personasPorDelante,
    required this.tiempoEstimadoMinutos,
    required this.fecha,
  });
}