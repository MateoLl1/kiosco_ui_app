import 'package:flutter/material.dart';
import 'package:kiosco_au/config/theme/guardia_theme.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class CitaTitle extends StatefulWidget {
  final Cita cita;
  final GuardiaTablaAnchos anchos;
  final bool isWide;
  final VoidCallback onTap;

  const CitaTitle({
    super.key,
    required this.cita,
    required this.anchos,
    required this.isWide,
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
    final acento = resolverColorCita(guardia, widget.cita.estado, widget.cita.tipoLabor);
    final anchos = widget.anchos;
    final isWide = widget.isWide;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: anchos.anchoFila,
          decoration: BoxDecoration(
            // Tinte suave de fondo con el mismo color de la barra, para que
            // el tipo se note en toda la fila y no solo en una franja
            // angosta a la izquierda.
            color: Color.alphaBlend(acento.withValues(alpha: 0.10), colors.surface),
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
                  width: GuardiaTablaAnchos.acento,
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
                      horizontal: anchos.paddingHorizontal,
                      vertical: isWide ? 14 : 12,
                    ),
                    child: _CitaFila(cita: widget.cita, anchos: anchos, isWide: isWide),
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
  final GuardiaTablaAnchos anchos;
  final bool isWide;

  const _CitaFila({
    required this.cita,
    required this.anchos,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: anchos.hora,
          child: Text(
            cita.horaCita,
            maxLines: 1,
            style: GuardiaColumnaEstilos.hora(isWide).copyWith(color: colors.onSurface),
          ),
        ),
        SizedBox(width: anchos.espacioColumnas),
        SizedBox(
          width: anchos.placa,
          child: Text(
            cita.placa,
            maxLines: 1,
            style: GuardiaColumnaEstilos.placa(isWide).copyWith(color: colors.onSurface),
          ),
        ),
        SizedBox(width: anchos.espacioColumnas),
        SizedBox(
          width: anchos.cliente,
          child: Text(
            cita.nombreCliente,
            maxLines: 1,
            style: GuardiaColumnaEstilos.cliente(isWide).copyWith(color: colors.onSurface),
          ),
        ),
        SizedBox(width: anchos.espacioColumnas),
        SizedBox(
          width: anchos.bahia,
          child: Text(
            cita.bahia,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: GuardiaColumnaEstilos.bahia(isWide).copyWith(color: colors.onSurface),
          ),
        ),
      ],
    );
  }
}
