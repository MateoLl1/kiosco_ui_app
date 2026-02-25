import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final colors = Theme.of(context).colorScheme;
    

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: HomePainter(
                  primaryColor: colors.primary
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 48 : 24,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HomeHeader(
                          title: 'Bienvenido',
                          subtitle: 'Seleccione el área a la que se dirige',
                        ),
                        const SizedBox(height: 32),
                        if (isWide)
                          Row(
                            children: [
                              Expanded(
                                child: HomeOptionCard(
                                  title: 'Taller / Servicios',
                                  icon: Icons.car_repair,
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  onTap: () => context.go('/service'),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: HomeOptionCard(
                                  title: 'Mostrador de Repuestos',
                                  icon: Icons.inventory_2_outlined,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  foregroundColor:
                                      colors.onSurfaceVariant,
                                  onTap: () => context.go('/parts'),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              HomeOptionCard(
                                title: 'Taller / Servicios',
                                icon: Icons.car_repair,
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                onTap: () => context.go('/service'),
                              ),
                              const SizedBox(height: 20),
                              HomeOptionCard(
                                title: 'Mostrador de Repuestos',
                                icon: Icons.inventory_2_outlined,
                                backgroundColor:
                                    colors.surfaceContainerHighest,
                                foregroundColor:
                                    colors.onSurfaceVariant,
                                onTap: () => context.go('/parts'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                
                const AcFooter(),



              ],
            ),
          ],
        ),
      ),
    );
  }
}