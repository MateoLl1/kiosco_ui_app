import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

/// Estilos de cada columna. Se definen acá para que la medición de ancho
/// (GuardiaTablaAnchos.calcular) y el render real (GuardiaTablaHeader,
/// CitaTitle) usen exactamente el mismo estilo — si no coincidieran, medir
/// el ancho del texto no serviría de nada.
class GuardiaColumnaEstilos {
  const GuardiaColumnaEstilos._();

  // fontFamily explícito en los 5: TextPainter (usado para medir el ancho
  // de columna) no hereda el 'Montserrat' de ThemeData como sí lo hace el
  // Text real en pantalla, así que si no coincidieran acá la medición
  // quedaría corta y la placa se vería recortada según los caracteres.
  static const _fontFamily = 'Montserrat';

  static TextStyle hora(bool isWide) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: isWide ? 20 : 16,
        fontWeight: FontWeight.w800,
      );

  static TextStyle placa(bool isWide) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: isWide ? 18 : 15,
        fontWeight: FontWeight.w700,
      );

  static TextStyle cliente(bool isWide) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: isWide ? 17 : 14,
        fontWeight: FontWeight.w700,
      );

  static TextStyle bahia(bool isWide) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: isWide ? 20 : 16,
        fontWeight: FontWeight.w800,
      );

  static TextStyle header(bool isWide) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: isWide ? 20 : 14,
        fontWeight: FontWeight.w700,
      );
}

/// Anchos de columna calculados a partir del contenido real de las citas
/// visibles y del tamaño de letra que el usuario configuró a nivel de
/// sistema operativo (accesibilidad). El texto nunca se recorta: si la
/// letra del sistema es grande, las columnas crecen y la tabla completa se
/// ve desplazando hacia los lados (GuardiaBody ya envuelve todo en un
/// scroll horizontal).
class GuardiaTablaAnchos {
  static const double acento = 6;

  final double hora;
  final double placa;
  final double cliente;
  final double bahia;
  final double espacioColumnas;
  final double paddingHorizontal;

  const GuardiaTablaAnchos({
    required this.hora,
    required this.placa,
    required this.cliente,
    required this.bahia,
    required this.espacioColumnas,
    required this.paddingHorizontal,
  });

  double get anchoContenido =>
      hora + placa + cliente + bahia + espacioColumnas * 3;

  double get anchoFila => acento + paddingHorizontal * 2 + anchoContenido;

  factory GuardiaTablaAnchos.calcular({
    required List<Cita> citas,
    required bool isWide,
    required TextScaler textScaler,
  }) {
    // Mínimos a tamaño de letra normal, para que columnas de contenido
    // corto (ej. bahía "1") no queden angostas de forma extraña.
    final minHora = isWide ? 90.0 : 68.0;
    final minPlaca = isWide ? 130.0 : 96.0;
    final minCliente = isWide ? 200.0 : 160.0;
    final minBahia = isWide ? 90.0 : 64.0;
    const colchon = 6.0;
    // La hora queda con más margen que el resto: el dígito final seguía
    // saliendo cortado aun con el colchón general.
    const colchonHora = 18.0;

    double medir(String texto, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: texto, style: style),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();
      return painter.width;
    }

    final estiloHora = GuardiaColumnaEstilos.hora(isWide);
    final estiloPlaca = GuardiaColumnaEstilos.placa(isWide);
    final estiloCliente = GuardiaColumnaEstilos.cliente(isWide);
    final estiloBahia = GuardiaColumnaEstilos.bahia(isWide);
    final estiloHeader = GuardiaColumnaEstilos.header(isWide);

    var anchoHora = medir('Hora', estiloHeader);
    var anchoPlaca = medir('Placa', estiloHeader);
    var anchoCliente = medir('Cliente', estiloHeader);
    var anchoBahia = medir('Bahía', estiloHeader);

    for (final cita in citas) {
      anchoHora = math.max(anchoHora, medir(cita.horaCita, estiloHora));
      anchoPlaca = math.max(anchoPlaca, medir(cita.placa, estiloPlaca));
      anchoCliente = math.max(anchoCliente, medir(cita.nombreCliente, estiloCliente));
      anchoBahia = math.max(anchoBahia, medir(cita.bahia, estiloBahia));
    }

    return GuardiaTablaAnchos(
      hora: math.max(minHora, anchoHora + colchonHora),
      placa: math.max(minPlaca, anchoPlaca + colchon),
      cliente: math.max(minCliente, anchoCliente + colchon),
      bahia: math.max(minBahia, anchoBahia + colchon),
      espacioColumnas: isWide ? 20 : 14,
      paddingHorizontal: isWide ? 16 : 12,
    );
  }
}
