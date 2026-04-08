import 'package:kiosco_au/domain/domain.dart';

class CitaMapper {
  static Cita citaToEntity(Map<String, dynamic> json) {
    return Cita(
      codigoCita: json['codigoCita'] as int,
      horaCita: json['horaCita'] as String? ?? '',
      placa: json['placa'] as String? ?? '',
      nombreCliente: json['nombreCliente'] as String? ?? '',
      modeloVehiculo: json['modeloVehiculo'] as String? ?? '',
      bahia: json['bahia'] as String? ?? '',
      estatus: (json['estatus'] as num?)?.toDouble() ?? 0,
      tlCodigo: (json['tlCodigo'] as num?)?.toDouble() ?? 0,
      estado: json['estado'] as String? ?? '',
      tipoLabor: json['tipoLabor'] as String? ?? '',
      claveVisual: json['claveVisual'] as String? ?? '',
    );
  }
}