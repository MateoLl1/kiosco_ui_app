import 'package:flutter/material.dart';
import 'package:kiosco_au/config/config.dart';

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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isWide ? 24 : 16,
        12,
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
          Material(
            color: colors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            child: IconButton(
              onPressed: cargando ? null : onActualizar,
              tooltip: 'Actualizar',
              icon: cargando
                  ? SizedBox(
                      width: isWide ? 22 : 18,
                      height: isWide ? 22 : 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: colors.primary,
                      ),
                    )
                  : Icon(
                      Icons.refresh_rounded,
                      size: isWide ? 28 : 24,
                      color: colors.primary,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}