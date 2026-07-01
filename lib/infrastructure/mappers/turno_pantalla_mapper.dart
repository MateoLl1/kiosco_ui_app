

import 'package:kiosco_au/domain/domain.dart';

class TurnoPantallaMapper {
  static Turno fromJson(Map<String, dynamic> json) {
    return Turno(
      asgCodigo: (json['asgCodigo'] as num?)?.toInt() ?? 0,
      turno: json['turno']?.toString() ?? '',
      modulo: json['modulo']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      tiempo: (json['tiempo'] as num?)?.toInt() ?? 0,
      tipo: json['tipo']?.toString() ?? '',
      requiereCambioEstado: json['requiereCambioEstado'] == true,
      esTurnoActual: json['esTurnoActual'] == true,
      nombreCliente: json['nombreCliente']?.toString() ?? '',
      fechaReferencia: json['fechaReferencia'] != null
          ? DateTime.tryParse(json['fechaReferencia'].toString())
          : null,
    );
  }
}


class PantallaTurnosMapper {
  static PantallaTurnosResponse fromJson(Map<String, dynamic> json) {
    return PantallaTurnosResponse(
      turnos: (json['turnos'] as List<dynamic>? ?? [])
          .map((item) => TurnoPantallaMapper.fromJson(item as Map<String, dynamic>))
          .toList(),
      turnoActual: json['turnoActual'] != null
          ? TurnoPantallaMapper.fromJson(json['turnoActual'] as Map<String, dynamic>)
          : null,
      turnosActivos: (json['turnosActivos'] as List<dynamic>? ?? [])
          .map((item) => TurnoPantallaMapper.fromJson(item as Map<String, dynamic>))
          .toList(),
      turnosRecienLlamados: (json['turnosRecienLlamados'] as List<dynamic>? ?? [])
          .map((item) => TurnoPantallaMapper.fromJson(item as Map<String, dynamic>))
          .toList(),
      turnosPendientes: (json['turnosPendientes'] as List<dynamic>? ?? [])
          .map((item) => TurnoPantallaMapper.fromJson(item as Map<String, dynamic>))
          .toList(),
      modulosActivos: (json['modulosActivos'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toInt())
          .toList(),
    );
  }
}