class RegistrarLlegadaResponse {
  final String resultado;
  final String turno;
  final String? bahia;
  final String? tecnico;
  final int? codigo;
  final String mensaje;

  RegistrarLlegadaResponse({
    required this.resultado,
    required this.turno,
    required this.bahia,
    required this.tecnico,
    required this.codigo,
    required this.mensaje,
  });
}