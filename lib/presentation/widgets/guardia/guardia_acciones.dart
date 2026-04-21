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
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Row(
            children: [
              Expanded(
                child: AccionGuardiaButton(
                  titulo: 'Sin cita',
                  onPressed: onSinCita,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AccionGuardiaButton(
                  titulo: 'Sin cita flotas',
                  onPressed: onSinCitaFlotas,
                ),
              ),
            ],
          ),
        ),
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
        minimumSize: Size.fromHeight(isWide ? 64 : 58),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isWide ? 26 : 22),
        ),
      ),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: isWide ? 18 : 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}