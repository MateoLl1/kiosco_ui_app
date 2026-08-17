/// Anchos fijos compartidos por [GuardiaTablaHeader] y las filas de
/// [CitaTitle]. Al ser fijos (no flex) el texto nunca se aprieta ni se parte
/// en dos líneas — si la tabla no entra en la pantalla, se desplaza
/// lateralmente en vez de comprimir las columnas.
class GuardiaTablaColumnas {
  const GuardiaTablaColumnas._();

  static const double acento = 6;

  static double hora(bool isWide) => isWide ? 90 : 68;
  static double placa(bool isWide) => isWide ? 130 : 96;
  static double cliente(bool isWide) => isWide ? 280 : 200;
  static double bahia(bool isWide) => isWide ? 90 : 64;
  static double espacioColumnas(bool isWide) => isWide ? 20 : 14;
  static double paddingHorizontal(bool isWide) => isWide ? 16 : 12;

  /// Ancho de las 4 columnas de datos más los 3 espacios entre ellas.
  static double anchoContenido(bool isWide) {
    return hora(isWide) +
        placa(isWide) +
        cliente(isWide) +
        bahia(isWide) +
        espacioColumnas(isWide) * 3;
  }

  /// Ancho total de una fila o del header: barra de acento (o su espaciador
  /// equivalente en el header) + padding a ambos lados + columnas de datos.
  static double anchoFila(bool isWide) {
    return acento + paddingHorizontal(isWide) * 2 + anchoContenido(isWide);
  }
}
