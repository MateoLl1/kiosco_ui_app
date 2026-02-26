
import 'package:flutter/material.dart';

class CustomTextCard extends StatelessWidget {
  const CustomTextCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Card(
      color: colors.primaryContainer,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          'Tome asiento en la sala de espera. Su turno será llamado en pantalla.',
          style: textStyle.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}