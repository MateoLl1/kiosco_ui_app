import 'package:flutter/material.dart';

class GuardiaLeyenda extends StatelessWidget {
  final bool isWide;

  const GuardiaLeyenda({
    super.key,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          LeyendaItem(
            color: colors.primaryContainer,
            texto: 'Mantenimiento',
          ),
          LeyendaItem(
            color: colors.secondaryContainer,
            texto: 'Reparación',
          ),
          LeyendaItem(
            color: colors.tertiaryContainer,
            texto: 'Servicio rápido',
          ),
          LeyendaItem(
            color: colors.error,
            texto: 'No llegó',
            textColor: colors.onError,
          ),
          LeyendaItem(
            color: colors.errorContainer,
            texto: 'Cancelado',
            textColor: colors.onErrorContainer,
          ),
        ],
      ),
    );
  }
}

class LeyendaItem extends StatelessWidget {
  final Color color;
  final String texto;
  final Color? textColor;

  const LeyendaItem({
    super.key,
    required this.color,
    required this.texto,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isWide ? 22 : 18,
          height: isWide ? 22 : 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: colors.outlineVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(
            color: textColor ?? colors.onSurface,
            fontSize: isWide ? 15 : 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}