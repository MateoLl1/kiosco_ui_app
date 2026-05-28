import 'package:kiosco_au/domain/domain.dart';

class TurnoGeneradoResponseMapper {
  static TurnoGeneradoResponse fromJson(Map<String, dynamic> json) {
    return TurnoGeneradoResponse(
      asgCodigo: _toDouble(json['asgCodigo'] ?? json['codigo']),
      turno: json['turno']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      area: json['area']?.toString() ?? _obtenerAreaPorTipo(json['tipo']),
      estado: json['estado']?.toString() ?? '',
      modulo: json['modulo']?.toString() ?? '',
      agenciaId: _toDouble(json['agenciaId']),
      personasPorDelante: _toInt(json['personasPorDelante']),
      tiempoEstimadoMinutos: _toInt(json['tiempoEstimadoMinutos']),
      fecha: _toDate(json['fecha']),
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

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }

  static String _obtenerAreaPorTipo(dynamic tipo) {
    final valor = tipo?.toString().trim().toLowerCase() ?? '';

    if (valor == 'flota') return 'Flota de Empresa';

    return 'Taller / Servicios';
  }
}