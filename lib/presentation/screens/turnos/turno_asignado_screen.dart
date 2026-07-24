import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';

class TurnoAsignadoScreen extends ConsumerWidget {
  final Object? extra;

  const TurnoAsignadoScreen({super.key, this.extra});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final clienteProvider = ref.watch(clienteSiacProvider);
    final isWide = MediaQuery.of(context).size.width >= 900;

    final turnoCliente = extra is TurnoClienteResponse
        ? extra as TurnoClienteResponse
        : null;

    final turnoGenerado = extra is TurnoGeneradoResponse
        ? extra as TurnoGeneradoResponse
        : null;

    final turnoTexto = turnoCliente?.turno.trim().isNotEmpty == true
        ? turnoCliente!.turno.trim()
        : turnoGenerado?.turno.trim().isNotEmpty == true
        ? turnoGenerado!.turno.trim()
        : '---';

    final clienteTexto = turnoCliente?.cliente.trim().isNotEmpty == true
        ? turnoCliente!.cliente.trim()
        : clienteProvider?.nombreCompleto.trim().isNotEmpty == true
        ? clienteProvider!.nombreCompleto.trim()
        : 'Estimado Cliente';

    final areaTexto = turnoCliente?.area.trim().isNotEmpty == true
        ? turnoCliente!.area.trim()
        : turnoGenerado?.area.trim().isNotEmpty == true
        ? turnoGenerado!.area.trim()
        : 'Taller / Servicios';

    final tipoTexto = turnoCliente?.tipo.trim().isNotEmpty == true
        ? AppValidators.formatearTipoTurno(turnoCliente!.tipo)
        : turnoGenerado?.tipo.trim().isNotEmpty == true
        ? AppValidators.formatearTipoTurno(turnoGenerado!.tipo)
        : 'Sin cita';

    final personasPorDelante =
        turnoCliente?.personasPorDelante ?? turnoGenerado?.personasPorDelante;

    final colaTexto = personasPorDelante == null
        ? '-- persona(s) antes'
        : '$personasPorDelante persona(s) antes';

    final telefonoInicial = _obtenerTelefonoInicial(
      turnoCliente: turnoCliente,
      cliente: clienteProvider,
    );

    final turnoCard = Card(
      color: colors.onSecondary,
      elevation: 2,
      shadowColor: colors.onSurface,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isWide ? 20 : 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              color: colors.surface,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                child: Text(
                  turnoTexto,
                  style: textStyle.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colors.primary,
                  ),
                ),
              ),
            ),
            const Divider(),
            DetalleTurno(label: 'Cliente', descripcion: clienteTexto, icon: Icons.person),
            DetalleTurno(label: 'Área', descripcion: areaTexto, icon: Icons.handyman_outlined),
            DetalleTurno(label: 'Tipo', descripcion: tipoTexto, icon: Icons.confirmation_number),
            DetalleTurno(label: 'En cola', descripcion: colaTexto, icon: Icons.people),
          ],
        ),
      ),
    );

    final acciones = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextCard(),
        const SizedBox(height: 10),
        WhatsappTurnoNotificacion(
          numeroInicial: telefonoInicial,
          cliente: clienteTexto,
          turno: turnoTexto,
          area: areaTexto,
        ),
        const SizedBox(height: 10),
        CustomIconTextButton(
          texto: 'Volver al inicio',
          icono: Icons.home,
          colorFondo: colors.primary,
          onTap: () {
            ref.read(clienteSiacProvider.notifier).limpiar();
            context.go('/seleccionar-metodo');
          },
        ),
      ],
    );

    return KioskIdleDetector(
      timeout: AppDurations.kioskIdleTurno,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: HomePainter(
                    primaryColor: Theme.of(context)
                            .extension<AppSeedColorTheme>()
                            ?.seed ??
                        colors.primary,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: ReturnPageButton(ruta: '/seleccionar-metodo'),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 40 : 20,
                    52,
                    isWide ? 40 : 20,
                    16,
                  ),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  HomeHeader(
                                    title: 'Turno asignado',
                                    subtitle: 'Su turno ha sido generado exitosamente',
                                  ),
                                  const SizedBox(height: 20),
                                  turnoCard,
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            SizedBox(
                              width: 380,
                              child: acciones,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HomeHeader(
                              title: 'Turno asignado',
                              subtitle: 'Su turno ha sido generado exitosamente',
                            ),
                            const SizedBox(height: 12),
                            turnoCard,
                            const SizedBox(height: 10),
                            acciones,
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _obtenerTelefonoInicial({
    TurnoClienteResponse? turnoCliente,
    ClienteSiac? cliente,
  }) {
    if (turnoCliente != null) {
      final normalizado = AppValidators.normalizarTelefono(
        turnoCliente.telefonoCliente,
      );
      if (normalizado.isNotEmpty) return normalizado;
    }

    if (cliente != null) {
      final normalizado1 = AppValidators.normalizarTelefono(
        cliente.telefono1,
      );
      if (normalizado1.isNotEmpty) return normalizado1;

      final normalizado2 = AppValidators.normalizarTelefono(
        cliente.telefono2,
      );
      if (normalizado2.isNotEmpty) return normalizado2;
    }

    return '';
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
            child: Text(label, style: textStyle.titleMedium),
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
