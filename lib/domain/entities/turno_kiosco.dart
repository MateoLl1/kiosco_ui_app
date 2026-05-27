class TurnoKiosco {
  final double asgCodigo;
  final String turno;
  final double agenciaId;
  final double clCodigo;
  final String identificacion;
  final String cliente;
  final String estado;
  final String modulo;
  final int personasPorDelante;
  final int tiempoEstimadoMinutos;
  final DateTime? fecha;

  TurnoKiosco({
    required this.asgCodigo,
    required this.turno,
    required this.agenciaId,
    required this.clCodigo,
    required this.identificacion,
    required this.cliente,
    required this.estado,
    required this.modulo,
    required this.personasPorDelante,
    required this.tiempoEstimadoMinutos,
    required this.fecha,
  });

  factory TurnoKiosco.fromJson(Map<String, dynamic> json) {
    return TurnoKiosco(
      asgCodigo: _toDouble(json['asgCodigo']),
      turno: json['turno']?.toString() ?? '',
      agenciaId: _toDouble(json['agenciaId']),
      clCodigo: _toDouble(json['clCodigo']),
      identificacion: json['identificacion']?.toString() ?? '',
      cliente: json['cliente']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      modulo: json['modulo']?.toString() ?? '',
      personasPorDelante: _toInt(json['personasPorDelante']),
      tiempoEstimadoMinutos: _toInt(json['tiempoEstimadoMinutos']),
      fecha: json['fecha'] == null ? null : DateTime.tryParse(json['fecha'].toString()),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}