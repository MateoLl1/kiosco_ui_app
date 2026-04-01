import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TipoAtencionScreen extends StatelessWidget {
  const TipoAtencionScreen({super.key});

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
                painter: HomePainter(primaryColor: colors.primary),
              ),
            ),
            Positioned(top: 16, left: 16, child: ReturnPageButton()),
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
                          title: 'Tipo de atención',
                          subtitle:
                              'Seleccione el tipo de servicio que necesita',
                        ),
                        const SizedBox(height: 32),
                        if (isWide)
                          Row(
                            children: [
                              Expanded(
                                child: HomeOptionCard(
                                  title: 'Servicio / Personal',
                                  icon: Icons.person,
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  onTap: () => context.push('/taller-servicio'),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: HomeOptionCard(
                                  title: 'Flota de Empresa',
                                  icon: Icons.clear_all_outlined,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  foregroundColor: colors.onSurfaceVariant,
                                  onTap: () => context.push('/ingresar-ruc'),
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
                                onTap: () => context.push('/taller-servicio'),
                              ),
                              const SizedBox(height: 20),
                              HomeOptionCard(
                                title: 'Flota de Empresa',
                                icon: Icons.clear_all_outlined,
                                backgroundColor: colors.surfaceContainerHighest,
                                foregroundColor: colors.onSurfaceVariant,
                                onTap: () => context.push('/ingresar-ruc'),
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
