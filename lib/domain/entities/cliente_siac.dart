class ClienteSiac {
  final double clCodigo;
  final String identificacion;
  final String tipoIdentificacion;
  final String nombres;
  final String apellidos;
  final String nombreCompleto;
  final DateTime? fechaNacimiento;
  final String telefono1;
  final String telefono2;
  final String correo;
  final double? ugCodigo;
  final double? usCodigo;

  ClienteSiac({
    required this.clCodigo,
    required this.identificacion,
    required this.tipoIdentificacion,
    required this.nombres,
    required this.apellidos,
    required this.nombreCompleto,
    required this.fechaNacimiento,
    required this.telefono1,
    required this.telefono2,
    required this.correo,
    required this.ugCodigo,
    required this.usCodigo,
  });

  factory ClienteSiac.fromJson(Map<String, dynamic> json) {
    return ClienteSiac(
      clCodigo: _toDouble(json['clCodigo']),
      identificacion: json['identificacion']?.toString() ?? '',
      tipoIdentificacion: json['tipoIdentificacion']?.toString() ?? '',
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      nombreCompleto: json['nombreCompleto']?.toString() ?? '',
      fechaNacimiento: json['fechaNacimiento'] == null
          ? null
          : DateTime.tryParse(json['fechaNacimiento'].toString()),
      telefono1: json['telefono1']?.toString() ?? '',
      telefono2: json['telefono2']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      ugCodigo: json['ugCodigo'] == null ? null : _toDouble(json['ugCodigo']),
      usCodigo: json['usCodigo'] == null ? null : _toDouble(json['usCodigo']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}