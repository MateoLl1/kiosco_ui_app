import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class TipoAtencionScreen extends ConsumerStatefulWidget {
  const TipoAtencionScreen({super.key});

  @override
  ConsumerState<TipoAtencionScreen> createState() =>
      _TipoAtencionScreenState();
}

class _TipoAtencionScreenState extends ConsumerState<TipoAtencionScreen> {
  bool _generandoTurno = false;

  static const int _agenciaId = 1;

  Future<void> _generarTurno({required bool esFlota}) async {
    if (_generandoTurno) return;

    setState(() {
      _generandoTurno = true;
    });

    try {
      final repository = ref.read(kioscoRepositoryProvider);

      final turno = esFlota
          ? await repository.generarTurnoSinCitaFlotas(agenciaId: _agenciaId)
          : await repository.generarTurnoSinCita(agenciaId: _agenciaId);

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

  void _onServicioPersonalTap() {
    if (_generandoTurno) return;
    _generarTurno(esFlota: false);
  }

  void _onFlotaTap() {
    if (_generandoTurno) return;
    _generarTurno(esFlota: true);
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
              child: ReturnPageButton(),
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
                                  title: _generandoTurno
                                      ? 'Generando turno...'
                                      : 'Servicio / Personal',
                                  icon: _generandoTurno
                                      ? Icons.hourglass_top_rounded
                                      : Icons.person,
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  onTap: _onServicioPersonalTap,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: HomeOptionCard(
                                  title: _generandoTurno
                                      ? 'Generando turno...'
                                      : 'Flota de Empresa',
                                  icon: _generandoTurno
                                      ? Icons.hourglass_top_rounded
                                      : Icons.clear_all_outlined,
                                  backgroundColor:
                                      colors.surfaceContainerHighest,
                                  foregroundColor: colors.onSurfaceVariant,
                                  onTap: _onFlotaTap,
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              HomeOptionCard(
                                title: _generandoTurno
                                    ? 'Generando turno...'
                                    : 'Servicio / Personal',
                                icon: _generandoTurno
                                    ? Icons.hourglass_top_rounded
                                    : Icons.person,
                                backgroundColor: colors.primary,
                                foregroundColor: colors.onPrimary,
                                onTap: _onServicioPersonalTap,
                              ),
                              const SizedBox(height: 20),
                              HomeOptionCard(
                                title: _generandoTurno
                                    ? 'Generando turno...'
                                    : 'Flota de Empresa',
                                icon: _generandoTurno
                                    ? Icons.hourglass_top_rounded
                                    : Icons.clear_all_outlined,
                                backgroundColor:
                                    colors.surfaceContainerHighest,
                                foregroundColor: colors.onSurfaceVariant,
                                onTap: _onFlotaTap,
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