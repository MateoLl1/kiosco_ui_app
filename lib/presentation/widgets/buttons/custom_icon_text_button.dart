

import 'package:flutter/material.dart';

class CustomIconTextButton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback? onTap;
  final Color? colorFondo;
  final Color? colorTexto;

  const CustomIconTextButton({
    super.key,
    required this.texto,
    required this.icono,
    required this.onTap,
    this.colorFondo,
    this.colorTexto,
  });

  @override
  Widget build(BuildContext context) {
    

    return SizedBox(
      width: double.infinity,
      height: 68,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icono, size: 24),
        label: Text(
          texto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18),
          ),
          backgroundColor: WidgetStatePropertyAll(
            colorFondo ?? const Color(0xFF9E7A16),
          ),
          foregroundColor: WidgetStatePropertyAll(
            colorTexto ?? Colors.white,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}