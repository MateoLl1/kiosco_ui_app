class NotificarTurnoWhatsappRequest {
  final String numeroEnvio;
  final String cliente;
  final String turno;
  final String area;

  NotificarTurnoWhatsappRequest({
    required this.numeroEnvio,
    required this.cliente,
    required this.turno,
    required this.area,
  });

  Map<String, dynamic> toJson() {
    return {
      'numeroEnvio': numeroEnvio,
      'cliente': cliente,
      'turno': turno,
      'area': area,
    };
  }
}