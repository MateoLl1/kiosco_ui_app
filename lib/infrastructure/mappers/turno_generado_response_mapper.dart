import 'package:kiosco_au/domain/domain.dart';

class TurnoGeneradoResponseMapper {
  static TurnoGeneradoResponse fromJson(Map<String, dynamic> json) {
    return TurnoGeneradoResponse(
      turno: json['turno']?.toString() ?? '',
      codigo: json['codigo'] is int
          ? json['codigo'] as int
          : int.parse(json['codigo'].toString()),
      tipo: json['tipo']?.toString() ?? '',
      fecha: DateTime.parse(json['fecha'].toString()),
    );
  }
}