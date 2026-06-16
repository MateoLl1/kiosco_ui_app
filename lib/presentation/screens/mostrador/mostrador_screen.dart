import 'package:flutter/material.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class MostradorScreen extends StatelessWidget {
  const MostradorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomPaint(
        size: Size.infinite,
        painter: Home3Painter(primaryColor: colors.primary),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 28),
            child: Column(
              children: const [
                MostradorHeader(),
                SizedBox(height: 24),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: CurrentTurnCard(),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: QueueCard(),
                      ),
                    ],
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