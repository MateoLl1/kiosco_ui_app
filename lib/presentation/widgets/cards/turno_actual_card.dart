
import 'package:flutter/material.dart';
import 'package:kiosco_au/domain/domain.dart';

class TurnoActualCard extends StatelessWidget {
  final Turno turno;

  const TurnoActualCard({
    super.key, 
    required this.turno
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              turno.turno,
              style: textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              turno.nombreCliente,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Módulo: ${turno.modulo}',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}