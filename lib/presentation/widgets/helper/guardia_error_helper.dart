import 'package:flutter/material.dart';

void mostrarErrorGuardia(BuildContext context, String mensaje) {
  final colors = Theme.of(context).colorScheme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: colors.error,
      content: Text(
        mensaje,
        style: TextStyle(
          color: colors.onError,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}