import 'package:kiosco_au/domain/domain.dart';

class RegistrarLlegadaResponseMapper {
  static RegistrarLlegadaResponse fromJson(Map<String, dynamic> json) {
    return RegistrarLlegadaResponse(
      resultado: json['resultado']?.toString() ?? '',
      turno: json['turno']?.toString() ?? '',
      bahia: json['bahia']?.toString(),
      tecnico: json['tecnico']?.toString(),
      codigo: json['codigo'] is int ? json['codigo'] as int : int.tryParse(json['codigo']?.toString() ?? ''),
      mensaje: json['mensaje']?.toString() ?? '',
    );
  }
}