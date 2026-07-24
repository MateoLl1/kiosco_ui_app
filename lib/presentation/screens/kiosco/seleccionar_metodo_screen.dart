import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class SeleccionarMetodoScreen extends StatelessWidget {
  const SeleccionarMetodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return KioskIdleDetector(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: HomePainter(
                    primaryColor:
                        Theme.of(context).extension<AppSeedColorTheme>()?.seed ??
                            colors.primary,
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
                            subtitle: '¿Cómo desea identificarse?',
                          ),
                          const SizedBox(height: 32),
                          if (isWide)
                            Row(
                              children: [
                                Expanded(
                                  child: HomeOptionCard(
                                    title: 'Cédula / RUC',
                                    icon: Icons.badge_outlined,
                                    backgroundColor: colors.primary,
                                    foregroundColor: colors.onPrimary,
                                    onTap: () => context.go('/ingresar-ruc'),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: HomeOptionCard(
                                    title: 'Placa',
                                    icon: Icons.directions_car_outlined,
                                    backgroundColor:
                                        colors.surfaceContainerHighest,
                                    foregroundColor: colors.onSurfaceVariant,
                                    onTap: () => context.go('/ingresar-placa'),
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                HomeOptionCard(
                                  title: 'Cédula / RUC',
                                  icon: Icons.badge_outlined,
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  onTap: () => context.go('/ingresar-ruc'),
                                ),
                                const SizedBox(height: 24),
                                HomeOptionCard(
                                  title: 'Placa',
                                  icon: Icons.directions_car_outlined,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  foregroundColor: colors.onSurfaceVariant,
                                  onTap: () => context.go('/ingresar-placa'),
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
      ),
    );
  }
}
