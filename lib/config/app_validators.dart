class AppValidators {
  static String normalizarTelefono(String numero) {
    final digitos = numero.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitos.startsWith('593') && digitos.length == 12) {
      return '0${digitos.substring(3)}';
    }
    if (digitos.startsWith('0') && digitos.length == 10) return digitos;
    if (digitos.startsWith('9') && digitos.length == 9) return digitos;

    return '';
  }

  static bool telefonoEcuatoriano(String numero) {
    final digitos = numero.replaceAll(RegExp(r'[^0-9]'), '');
    return RegExp(r'^09[0-9]{8}$').hasMatch(digitos) ||
        RegExp(r'^9[0-9]{8}$').hasMatch(digitos);
  }

  static String formatearTipoTurno(String tipo) {
    switch (tipo.trim().toLowerCase()) {
      case 'con_cita':
        return 'Con cita';
      case 'sin_cita':
        return 'Sin cita';
      case 'flota':
        return 'Flota';
      case 'latoneria':
        return 'Latonería';
      default:
        return tipo;
    }
  }
}
