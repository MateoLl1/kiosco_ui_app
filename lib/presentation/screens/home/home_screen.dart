import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _generandoTurno = false;

  static const int _agenciaId = 1;

  Future<void> _generarTurno() async {
    if (_generandoTurno) return;

    final cliente = ref.read(clienteSiacProvider);

    if (cliente == null || cliente.clCodigo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No existe un cliente válido para generar el turno.'),
        ),
      );

      context.go('/ingresar-ruc');
      return;
    }

    setState(() {
      _generandoTurno = true;
    });

    try {
      final turno = await ref.read(turnoKioscoProvider.notifier).generarTurno(
            agenciaId: _agenciaId,
            clCodigo: cliente.clCodigo,
          );

      if (!mounted) return;
      context.go('/turno-asignado', extra: turno);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo generar el turno. $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _generandoTurno = false;
        });
      }
    }
  }

  void _onGenerarTurnoTap() {
    if (_generandoTurno) return;
    _generarTurno();
  }

  void _onTipoAtencionTap() {
    if (_generandoTurno) return;
    context.push('/tipo-atencion');
  }

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
              child: ReturnPageButton(
                ruta: '/ingresar-ruc',
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
                                  onTap: _onTipoAtencionTap,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: HomeOptionCard(
                                  title: _generandoTurno
                                      ? 'Generando turno...'
                                      : 'Mostrador de Repuestos',
                                  icon: _generandoTurno
                                      ? Icons.hourglass_top_rounded
                                      : Icons.inventory_2_outlined,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  foregroundColor: colors.onSurfaceVariant,
                                  onTap: _onGenerarTurnoTap,
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
                                onTap: _onTipoAtencionTap,
                              ),
                              const SizedBox(height: 24),
                              HomeOptionCard(
                                title: _generandoTurno
                                    ? 'Generando turno...'
                                    : 'Mostrador de Repuestos',
                                icon: _generandoTurno
                                    ? Icons.hourglass_top_rounded
                                    : Icons.inventory_2_outlined,
                                backgroundColor:
                                    colors.surfaceContainerHighest,
                                foregroundColor: colors.onSurfaceVariant,
                                onTap: _onGenerarTurnoTap,
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