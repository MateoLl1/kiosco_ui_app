import 'package:flutter/material.dart';

class GuardiaTablaHeader extends StatelessWidget {
  const GuardiaTablaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final esMovil = width < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 12,
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
        child: esMovil
            ? const Row(
                children: [
                  Expanded(child: Text('Hora')),
                  Expanded(child: Text('Placa')),
                  Expanded(flex: 2, child: Text('Cliente')),
                  Text('Bahía'),
                ],
              )
            : const Row(
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