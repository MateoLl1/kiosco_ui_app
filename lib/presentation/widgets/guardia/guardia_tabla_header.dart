import 'package:flutter/material.dart';

class GuardiaTablaHeader extends StatelessWidget {
  const GuardiaTablaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 12,
        vertical: isWide ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: colors.secondary, 
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: isWide ? 20 : 14,
        ),
        child: const Row(
          children: [
            Expanded(flex: 2, child: Text('Hora')),
            Expanded(flex: 2, child: Text('Placa')),
            Expanded(flex: 5, child: Text('Cliente')),
            Expanded(flex: 2, child: Text('Bahía', textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}