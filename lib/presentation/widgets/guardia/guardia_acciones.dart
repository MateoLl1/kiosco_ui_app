import 'package:flutter/material.dart';

class GuardiaAcciones extends StatelessWidget {
  final bool isWide;
  final VoidCallback onSinCita;
  final VoidCallback onSinCitaFlotas;

  const GuardiaAcciones({
    super.key,
    required this.isWide,
    required this.onSinCita,
    required this.onSinCitaFlotas,
  });

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        children: [
          Expanded(
            child: AccionGuardiaButton(
              titulo: 'Sin cita',
              onPressed: onSinCita,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AccionGuardiaButton(
              titulo: 'Sin cita flotas',
              onPressed: onSinCitaFlotas,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AccionGuardiaButton(
            titulo: 'Sin cita',
            onPressed: onSinCita,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: AccionGuardiaButton(
            titulo: 'Sin cita flotas',
            onPressed: onSinCitaFlotas,
          ),
        ),
      ],
    );
  }
}

class AccionGuardiaButton extends StatelessWidget {
  final String titulo;
  final VoidCallback onPressed;

  const AccionGuardiaButton({
    super.key,
    required this.titulo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(isWide ? 72 : 60),
      ),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: isWide ? 22 : 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}