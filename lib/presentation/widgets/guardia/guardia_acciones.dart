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
    final colors = Theme.of(context).colorScheme;

    final sinCita = _AccionCard(
      titulo: 'Sin cita',
      subtitulo: 'Ingreso directo al taller',
      icono: Icons.person_add_rounded,
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      onTap: onSinCita,
      autofocus: true,
    );

    final sinCitaFlotas = _AccionCard(
      titulo: 'Sin cita — Flotas',
      subtitulo: 'Vehículos de flota o empresa',
      icono: Icons.local_shipping_rounded,
      backgroundColor: colors.secondaryContainer,
      foregroundColor: colors.onSecondaryContainer,
      onTap: onSinCitaFlotas,
    );

    if (isWide) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: sinCita),
                const SizedBox(width: 16),
                Expanded(child: sinCitaFlotas),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        sinCita,
        const SizedBox(height: 12),
        sinCitaFlotas,
      ],
    );
  }
}

class _AccionCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;
  final bool autofocus;

  const _AccionCard({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(isWide ? 22 : 18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        autofocus: autofocus,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 22 : 18,
            vertical: isWide ? 20 : 16,
          ),
          child: Row(
            children: [
              Container(
                width: isWide ? 58 : 50,
                height: isWide ? 58 : 50,
                decoration: BoxDecoration(
                  color: foregroundColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icono,
                  color: foregroundColor,
                  size: isWide ? 30 : 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: isWide ? 17 : 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        color: foregroundColor.withValues(alpha: 0.72),
                        fontSize: isWide ? 13 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: foregroundColor.withValues(alpha: 0.50),
                size: isWide ? 26 : 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}