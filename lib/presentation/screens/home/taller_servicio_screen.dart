import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TallerServicioScreen extends StatelessWidget {
  const TallerServicioScreen({super.key});

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
                  primaryColor: colors.primary,
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.arrow_back),
                  ),
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
                          title: 'Taller / Servicios',
                          subtitle: '¿Tiene cita agendada?',
                        ),
                        const SizedBox(height: 32),
                        if (isWide)
                          Row(
                            children: [
                              Expanded(
                                child: HomeOptionCard(
                                  title: 'Sí, tengo cita',
                                  icon: Icons.event_available_outlined,
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  onTap: () => context.go('/service/appointment'),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: HomeOptionCard(
                                  title: 'No, sin cita',
                                  icon: Icons.event_busy_outlined,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  foregroundColor:
                                      colors.onSurfaceVariant,
                                  onTap: () => context.go('/service/walkin'),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              HomeOptionCard(
                                title: 'Sí, tengo cita',
                                icon: Icons.event_available_outlined,
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                onTap: () => context.go('/service/appointment'),
                              ),
                              const SizedBox(height: 20),
                              HomeOptionCard(
                                title: 'No, sin cita',
                                icon: Icons.event_busy_outlined,
                                backgroundColor:
                                    colors.surfaceContainerHighest,
                                foregroundColor:
                                    colors.onSurfaceVariant,
                                onTap: () => context.go('/service/walkin'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}