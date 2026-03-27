


import 'package:kiosco_au/domain/domain.dart';

class AgenciaMapper {
  static Agencia agenciaToEntity(Map<String, dynamic> json) {
    return Agencia(
      agCodigo: json['agCodigo'],
      agNombre: json['agNombre'],
      suCodigo: json['suCodigo'],
      agResponsable: json['agResponsable'],
      agDireccion: json['agDireccion'],
      agFechMovi: json['agFechMovi'],
      agTelefono1: json['agTelefono1'],
      agTelefono2: json['agTelefono2'],
    );
  }
}