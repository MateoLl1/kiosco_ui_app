import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaTablaHeader extends StatelessWidget {
  final GuardiaTablaAnchos anchos;
  final bool isWide;

  const GuardiaTablaHeader({
    super.key,
    required this.anchos,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: anchos.anchoFila,
      padding: EdgeInsets.symmetric(
        horizontal: anchos.paddingHorizontal,
        vertical: isWide ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle(
        style: GuardiaColumnaEstilos.header(isWide).copyWith(color: Colors.white),
        child: Row(
          children: [
            // Mismo ancho que la barra de acento de CitaTitle para que las
            // columnas de abajo queden alineadas con estos títulos.
            const SizedBox(width: GuardiaTablaAnchos.acento),
            SizedBox(width: anchos.hora, child: const Text('Hora')),
            SizedBox(width: anchos.espacioColumnas),
            SizedBox(width: anchos.placa, child: const Text('Placa')),
            SizedBox(width: anchos.espacioColumnas),
            SizedBox(width: anchos.cliente, child: const Text('Cliente')),
            SizedBox(width: anchos.espacioColumnas),
            SizedBox(
              width: anchos.bahia,
              child: const Text('Bahía', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
