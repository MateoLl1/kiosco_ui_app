

import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomPaint(
        size: Size.infinite,
        painter: Home2Painter(
          primaryColor: colors.primary,
          // secondaryColor: colors.secondary
        ),
      ),
    );
  }
}