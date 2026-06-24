import 'package:flutter/material.dart';

class TurneroAdEmpty extends StatelessWidget {
  const TurneroAdEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.surface,
            colors.primary.withValues(alpha: 0.08),
            colors.secondary.withValues(alpha: 0.08),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(
              'ESPACIO PUBLICITARIO',
              style: TextStyle(
                color: colors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Aquí puedes mostrar campañas,\nimágenes o videos mientras\nlos clientes esperan.',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 30,
                height: 1.25,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No hay archivos configurados para esta agencia.',
              style: TextStyle(
                color: colors.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class TurneroAdError extends StatelessWidget {
  final String mensaje;
  final String detalle;

  const TurneroAdError({
    super.key,
    required this.mensaje,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            'ESPACIO PUBLICITARIO',
            style: TextStyle(
              color: colors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mensaje,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 30,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            detalle,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class TurneroAdLoadingVideo extends StatelessWidget {
  final String url;

  const TurneroAdLoadingVideo({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surface,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          CircularProgressIndicator(color: colors.primary),
          const SizedBox(height: 24),
          Text(
            'Cargando video...',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            url,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.7),
              fontSize: 13,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
