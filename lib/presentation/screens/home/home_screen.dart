import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              onTap: () => context.go('/service'),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: HomeOptionCard(
                              title: 'Mostrador de Repuestos',
                              icon: Icons.inventory_2_outlined,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              foregroundColor:
                                  colorScheme.onSurfaceVariant,
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
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            onTap: () => context.go('/service'),
                          ),
                          const SizedBox(height: 20),
                          HomeOptionCard(
                            title: 'Mostrador de Repuestos',
                            icon: Icons.inventory_2_outlined,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            foregroundColor:
                                colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}