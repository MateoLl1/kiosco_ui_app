class TurnoGeneradoResponse {
  final String turno;
  final int codigo;
  final String tipo;
  final DateTime fecha;

  TurnoGeneradoResponse({
    required this.turno,
    required this.codigo,
    required this.tipo,
    required this.fecha,
  });
}