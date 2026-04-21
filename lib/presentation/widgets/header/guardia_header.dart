import 'package:flutter/material.dart';

class GuardiaHeader extends StatelessWidget {
  final String? agenciaNombre;
  final VoidCallback onActualizar;
  final bool cargando;

  const GuardiaHeader({
    super.key,
    required this.agenciaNombre,
    required this.onActualizar,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isWide ? 24 : 16,
        20,
        isWide ? 24 : 16,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              agenciaNombre == null ? 'Guardia' : 'Agencia: $agenciaNombre',
              style: TextStyle(
                fontSize: isWide ? 32 : 24,
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: cargando ? null : onActualizar,
            child: Text(
              'Actualizar',
              style: TextStyle(
                fontSize: isWide ? 18 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}