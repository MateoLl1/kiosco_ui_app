import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class CitaTitle extends StatelessWidget {
  final Cita cita;
  final VoidCallback onTap;

  const CitaTitle({
    super.key,
    required this.cita,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final guardia = Theme.of(context).extension<GuardiaTheme>()!;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final esMovil = width < 600;
    final fondo = resolverColorCita(guardia, cita.claveVisual);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 20 : 14,
              vertical: isWide ? 18 : 14,
            ),
            child: esMovil
                ? _CitaTitleMovil(
                    cita: cita,
                    colors: colors,
                  )
                : _CitaTileDesktop(
                    cita: cita,
                    colors: colors,
                    isWide: isWide,
                  ),
          ),
        ),
      ),
    );
  }
}

class _CitaTileDesktop extends StatelessWidget {
  final Cita cita;
  final ColorScheme colors;
  final bool isWide;

  const _CitaTileDesktop({
    required this.cita,
    required this.colors,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            cita.horaCita,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 24 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            cita.placa,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 20 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cita.nombreCliente,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: isWide ? 19 : 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cita.tipoLabor.replaceAll('_', ' '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: isWide ? 15 : 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            cita.bahia,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 22 : 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _CitaTitleMovil extends StatelessWidget {
  final Cita cita;
  final ColorScheme colors;

  const _CitaTitleMovil({
    required this.cita,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                cita.horaCita,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              cita.bahia,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          cita.placa,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          cita.nombreCliente,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          cita.tipoLabor.replaceAll('_', ' '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}