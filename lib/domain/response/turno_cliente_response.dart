class TurnoClienteResponse {
  final double asgCodigo;
  final String turno;
  final String estado;
  final String modulo;
  final double agenciaId;
  final double? tiempo;
  final double? tiempoEspera;
  final DateTime? fechaMovimiento;
  final DateTime? fechaAsignacion;
  final double clCodigo;
  final String identificacion;
  final String cliente;
  final double? citaId;
  final DateTime? fechaCita;
  final String horaCita;
  final String tipo;
  final String area;
  final String telefonoCliente;
  final int personasPorDelante;
  final int tiempoEstimadoMinutos;

  TurnoClienteResponse({
    required this.asgCodigo,
    required this.turno,
    required this.estado,
    required this.modulo,
    required this.agenciaId,
    required this.tiempo,
    required this.tiempoEspera,
    required this.fechaMovimiento,
    required this.fechaAsignacion,
    required this.clCodigo,
    required this.identificacion,
    required this.cliente,
    required this.citaId,
    required this.fechaCita,
    required this.horaCita,
    required this.tipo,
    required this.area,
    required this.telefonoCliente,
    required this.personasPorDelante,
    required this.tiempoEstimadoMinutos,
  });

  factory TurnoClienteResponse.fromJson(Map<String, dynamic> json) {
    return TurnoClienteResponse(
      asgCodigo: _toDouble(json['asgCodigo']),
      turno: json['turno']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      modulo: json['modulo']?.toString() ?? '',
      agenciaId: _toDouble(json['agenciaId']),
      tiempo: json['tiempo'] == null ? null : _toDouble(json['tiempo']),
      tiempoEspera: json['tiempoEspera'] == null
          ? null
          : _toDouble(json['tiempoEspera']),
      fechaMovimiento: _toDate(json['fechaMovimiento']),
      fechaAsignacion: _toDate(json['fechaAsignacion']),
      clCodigo: _toDouble(json['clCodigo']),
      identificacion: json['identificacion']?.toString() ?? '',
      cliente: json['cliente']?.toString() ?? '',
      citaId: json['citaId'] == null ? null : _toDouble(json['citaId']),
      fechaCita: _toDate(json['fechaCita']),
      horaCita: json['horaCita']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      telefonoCliente: json['telefonoCliente']?.toString() ?? '',
      personasPorDelante: _toInt(json['personasPorDelante']),
      tiempoEstimadoMinutos: _toInt(json['tiempoEstimadoMinutos']),
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

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}