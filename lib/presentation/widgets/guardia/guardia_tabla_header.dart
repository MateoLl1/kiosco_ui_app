import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaTablaHeader extends StatelessWidget {
  const GuardiaTablaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final espacio = GuardiaTablaColumnas.espacioColumnas(isWide);

    return Container(
      width: GuardiaTablaColumnas.anchoFila(isWide),
      padding: EdgeInsets.symmetric(
        horizontal: GuardiaTablaColumnas.paddingHorizontal(isWide),
        vertical: isWide ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: isWide ? 20 : 14,
        ),
        child: Row(
          children: [
            // Mismo ancho que la barra de acento de CitaTitle para que las
            // columnas de abajo queden alineadas con estos títulos.
            SizedBox(width: GuardiaTablaColumnas.acento),
            SizedBox(width: GuardiaTablaColumnas.hora(isWide), child: const Text('Hora')),
            SizedBox(width: espacio),
            SizedBox(width: GuardiaTablaColumnas.placa(isWide), child: const Text('Placa')),
            SizedBox(width: espacio),
            SizedBox(width: GuardiaTablaColumnas.cliente(isWide), child: const Text('Cliente')),
            SizedBox(width: espacio),
            SizedBox(
              width: GuardiaTablaColumnas.bahia(isWide),
              child: const Text('Bahía', textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
