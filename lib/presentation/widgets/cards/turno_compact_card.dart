

import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurnoCompactCard extends StatelessWidget {
  final Turno turno;

  const TurnoCompactCard({super.key, required this.turno});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(turno.turno),
        subtitle: Text(turno.nombreCliente),
        trailing: Text('Mód. ${turno.modulo}'),
      ),
    );
  }
}