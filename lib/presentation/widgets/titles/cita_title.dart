import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class CitaTitle extends StatefulWidget {
  final Cita cita;
  final VoidCallback onTap;

  const CitaTitle({
    super.key,
    required this.cita,
    required this.onTap,
  });

  @override
  State<CitaTitle> createState() => _CitaTitleState();
}

class _CitaTitleState extends State<CitaTitle> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final guardia = Theme.of(context).extension<GuardiaTheme>()!;
    final isWide = MediaQuery.of(context).size.width >= 900;
    final acento = resolverColorCita(guardia, widget.cita.claveVisual);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: GuardiaTablaColumnas.anchoFila(isWide),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? colors.primary
                  : colors.outline.withValues(alpha: 0.15),
              width: _isFocused ? 2.5 : 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Comunica el tipo de labor (ver GuardiaLeyenda) sin ocupar
                // una tarjeta entera coloreada — permite una fila por cita.
                Container(
                  width: GuardiaTablaColumnas.acento,
                  decoration: BoxDecoration(
                    color: acento,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: GuardiaTablaColumnas.paddingHorizontal(isWide),
                      vertical: isWide ? 14 : 12,
                    ),
                    child: _CitaFila(cita: widget.cita, isWide: isWide),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CitaFila extends StatelessWidget {
  final Cita cita;
  final bool isWide;

  const _CitaFila({required this.cita, required this.isWide});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final espacio = GuardiaTablaColumnas.espacioColumnas(isWide);

    return Row(
      children: [
        SizedBox(
          width: GuardiaTablaColumnas.hora(isWide),
          child: Text(
            cita.horaCita,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 20 : 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(width: espacio),
        SizedBox(
          width: GuardiaTablaColumnas.placa(isWide),
          child: Text(
            cita.placa,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 18 : 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: espacio),
        SizedBox(
          width: GuardiaTablaColumnas.cliente(isWide),
          child: Text(
            cita.nombreCliente,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 17 : 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: espacio),
        SizedBox(
          width: GuardiaTablaColumnas.bahia(isWide),
          child: Text(
            cita.bahia,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: isWide ? 20 : 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
