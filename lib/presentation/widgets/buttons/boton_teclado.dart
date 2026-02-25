import 'package:flutter/material.dart';

class BotonTeclado extends StatelessWidget {
  final String texto;
  final VoidCallback? onTap;
  final IconData? icono;
  final Color? colorFondo;
  final Color? colorTexto;

  const BotonTeclado({
    super.key,
    required this.texto,
    required this.onTap,
    this.icono,
    this.colorFondo,
    this.colorTexto,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: WidgetStatePropertyAll(
            colorFondo ?? colores.surfaceContainerHighest,
          ),
          foregroundColor: WidgetStatePropertyAll(
            colorTexto ?? colores.onSurface,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: icono != null
            ? Icon(icono, size: 22)
            : Text(
                texto,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}