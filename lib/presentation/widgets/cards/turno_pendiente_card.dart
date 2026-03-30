

import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurnoPendienteCard extends StatelessWidget {
  final Turno turno;

  const TurnoPendienteCard({super.key, required this.turno});

  String _tipoLabel(String tipo) {
    switch (tipo) {
      case 'con_cita':
        return 'Con cita';
      case 'sin_cita':
        return 'Sin cita';
      default:
        return tipo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        title: Text(
          turno.turno,
          style: textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(turno.nombreCliente),
            const SizedBox(height: 4),
            Text('Tipo: ${_tipoLabel(turno.tipo)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              turno.modulo,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(turno.estado),
          ],
        ),
      ),
    );
  }
}