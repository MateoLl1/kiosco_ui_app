import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';

class TurnoAsignadoScreen extends ConsumerWidget {
  const TurnoAsignadoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final turno = ref.watch(turnoKioscoProvider);

    final turnoTexto = turno?.turno.trim().isNotEmpty == true
        ? turno!.turno.trim()
        : '---';

    final clienteTexto = turno?.cliente.trim().isNotEmpty == true
        ? turno!.cliente.trim()
        : 'Estimado Cliente';

    final tiempoTexto = turno == null
        ? '-- min'
        : '~${turno.tiempoEstimadoMinutos} min';

    final colaTexto = turno == null
        ? '-- persona(s) antes'
        : '${turno.personasPorDelante} persona(s) antes';

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
              child: ReturnPageButton(
                ruta: '/ingresar-ruc',
              ),
            ),
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 430,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HomeHeader(
                          title: 'Turno asignado',
                          subtitle: 'Su turno ha sido generado exitosamente',
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Card(
                                color: colors.onSecondary,
                                elevation: 2,
                                shadowColor: colors.onSurface,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 30,
                                  ),
                                  child: Column(
                                    children: [
                                      Card(
                                        color: colors.surface,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 28,
                                            vertical: 18,
                                          ),
                                          child: Text(
                                            turnoTexto,
                                            style: textStyle.displaySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: colors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      DetalleTurno(
                                        label: 'Cliente',
                                        descripcion: clienteTexto,
                                        icon: Icons.person,
                                      ),
                                      DetalleTurno(
                                        label: 'Área',
                                        descripcion: 'Taller - Servicios',
                                        icon: Icons.handyman_outlined,
                                      ),
                                      DetalleTurno(
                                        label: 'Tiempo est.',
                                        descripcion: tiempoTexto,
                                        icon: Icons.timelapse,
                                      ),
                                      DetalleTurno(
                                        label: 'En cola',
                                        descripcion: colaTexto,
                                        icon: Icons.people,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomTextCard(),
                              const SizedBox(height: 10),
                              CustomIconTextButton(
                                texto: 'Volver al inicio',
                                icono: Icons.home,
                                colorFondo: colors.primary,
                                onTap: () {
                                  ref.read(clienteSiacProvider.notifier).limpiar();
                                  ref.read(turnoKioscoProvider.notifier).limpiar();
                                  context.go('/ingresar-ruc');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalleTurno extends StatelessWidget {
  final String label;
  final String descripcion;
  final IconData icon;

  const DetalleTurno({
    super.key,
    required this.label,
    required this.descripcion,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: textStyle.titleMedium,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                descripcion,
                style: textStyle.bodyLarge,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}