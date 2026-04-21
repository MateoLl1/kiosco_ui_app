import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';

class GuardiaLeyenda extends StatelessWidget {
  final bool isWide;

  const GuardiaLeyenda({
    super.key,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final guardia = Theme.of(context).extension<GuardiaTheme>()!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD2B48C),
        ),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          LeyendaItem(
            color: guardia.mantenimiento,
            texto: 'Mantenimiento',
          ),
          LeyendaItem(
            color: guardia.reparacion,
            texto: 'Reparación',
          ),
          LeyendaItem(
            color: guardia.noLlego,
            texto: 'No llegó',
          ),
          LeyendaItem(
            color: guardia.cancelado,
            texto: 'Cancelado',
          ),
        ],
      ),
    );
  }
}

class LeyendaItem extends StatelessWidget {
  final Color color;
  final String texto;

  const LeyendaItem({
    super.key,
    required this.color,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(
            fontSize: isWide ? 15 : 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}