import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

class GuardiaScreen extends ConsumerStatefulWidget {
  const GuardiaScreen({super.key});

  @override
  ConsumerState<GuardiaScreen> createState() => _GuardiaScreenState();
}

class _GuardiaScreenState extends ConsumerState<GuardiaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_cargarCitas);
  }

  Future<void> _cargarCitas() async {
    await ref.read(citasGuardiaProvider.notifier).loadCitas();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionProvider);
    final state = ref.watch(citasGuardiaProvider);
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _GuardiaHeader(
              agenciaId: session?.agenciaId,
              onActualizar: _cargarCitas,
              cargando: state.isLoading,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
              child: _GuardiaAcciones(
                isWide: isWide,
                onSinCita: () {},
                onSinCitaFlotas: () {},
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
                child: _GuardiaBody(
                  state: state,
                  onRefresh: _cargarCitas,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
              child: _GuardiaLeyenda(isWide: isWide),
            ),
            const SizedBox(height: 12),
            const _GuardiaFooter(),
          ],
        ),
      ),
    );
  }
}

class _GuardiaHeader extends StatelessWidget {
  final int? agenciaId;
  final VoidCallback onActualizar;
  final bool cargando;

  const _GuardiaHeader({
    required this.agenciaId,
    required this.onActualizar,
    required this.cargando,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isWide ? 24 : 16,
        20,
        isWide ? 24 : 16,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              agenciaId == null ? 'Guardia' : 'Agencia: $agenciaId',
              style: TextStyle(
                fontSize: isWide ? 32 : 24,
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(
            onPressed: cargando ? null : onActualizar,
            child: Text(
              'Actualizar',
              style: TextStyle(
                fontSize: isWide ? 18 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuardiaAcciones extends StatelessWidget {
  final bool isWide;
  final VoidCallback onSinCita;
  final VoidCallback onSinCitaFlotas;

  const _GuardiaAcciones({
    required this.isWide,
    required this.onSinCita,
    required this.onSinCitaFlotas,
  });

  @override
  Widget build(BuildContext context) {
    if (isWide) {
      return Row(
        children: [
          Expanded(
            child: _AccionGuardiaButton(
              titulo: 'Sin cita',
              onPressed: onSinCita,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _AccionGuardiaButton(
              titulo: 'Sin cita flotas',
              onPressed: onSinCitaFlotas,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _AccionGuardiaButton(
            titulo: 'Sin cita',
            onPressed: onSinCita,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _AccionGuardiaButton(
            titulo: 'Sin cita flotas',
            onPressed: onSinCitaFlotas,
          ),
        ),
      ],
    );
  }
}

class _AccionGuardiaButton extends StatelessWidget {
  final String titulo;
  final VoidCallback onPressed;

  const _AccionGuardiaButton({
    required this.titulo,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: Size.fromHeight(isWide ? 72 : 60),
      ),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: isWide ? 22 : 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GuardiaBody extends StatelessWidget {
  final AsyncValue<List<Cita>> state;
  final Future<void> Function() onRefresh;

  const _GuardiaBody({
    required this.state,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return state.when(
      loading: () => Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      ),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.error,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      data: (citas) {
        if (citas.isEmpty) {
          return Center(
            child: Text(
              'No hay citas disponibles',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }

        return Column(
          children: [
            const _GuardiaTablaHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: citas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _CitaTile(cita: citas[index]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GuardiaTablaHeader extends StatelessWidget {
  const _GuardiaTablaHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 12,
        vertical: isWide ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: colors.onInverseSurface,
          fontWeight: FontWeight.w700,
          fontSize: isWide ? 20 : 14,
        ),
        child: const Row(
          children: [
            Expanded(flex: 2, child: Text('Hora')),
            Expanded(flex: 2, child: Text('Placa')),
            Expanded(flex: 5, child: Text('Cliente')),
            Expanded(flex: 2, child: Text('Bahía', textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}

class _CitaTile extends StatelessWidget {
  final Cita cita;

  const _CitaTile({
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;
    final estilo = _resolverEstilo(colors, cita.claveVisual);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: estilo.fondo,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: estilo.borde,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 20 : 12,
              vertical: isWide ? 18 : 14,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    cita.horaCita,
                    style: TextStyle(
                      color: estilo.texto,
                      fontSize: isWide ? 24 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    cita.placa,
                    style: TextStyle(
                      color: estilo.texto,
                      fontSize: isWide ? 20 : 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cita.nombreCliente,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: estilo.texto,
                          fontSize: isWide ? 19 : 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cita.tipoLabor.replaceAll('_', ' '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: estilo.textoSecundario,
                          fontSize: isWide ? 15 : 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    cita.bahia,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: estilo.texto,
                      fontSize: isWide ? 22 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _EstiloCita _resolverEstilo(ColorScheme colors, String claveVisual) {
    switch (claveVisual.toLowerCase()) {
      case 'cancelado':
        return _EstiloCita(
          fondo: colors.errorContainer,
          borde: colors.error,
          texto: colors.onErrorContainer,
          textoSecundario: colors.onErrorContainer.withOpacity(0.82),
        );
      case 'no_llego':
        return _EstiloCita(
          fondo: colors.error,
          borde: colors.error,
          texto: colors.onError,
          textoSecundario: colors.onError.withOpacity(0.82),
        );
      case 'mantenimiento':
        return _EstiloCita(
          fondo: colors.primaryContainer,
          borde: colors.primary,
          texto: colors.onPrimaryContainer,
          textoSecundario: colors.onPrimaryContainer.withOpacity(0.82),
        );
      case 'reparacion':
        return _EstiloCita(
          fondo: colors.secondaryContainer,
          borde: colors.secondary,
          texto: colors.onSecondaryContainer,
          textoSecundario: colors.onSecondaryContainer.withOpacity(0.82),
        );
      case 'servicio_rapido':
        return _EstiloCita(
          fondo: colors.tertiaryContainer,
          borde: colors.tertiary,
          texto: colors.onTertiaryContainer,
          textoSecundario: colors.onTertiaryContainer.withOpacity(0.82),
        );
      default:
        return _EstiloCita(
          fondo: colors.surfaceContainerHighest,
          borde: colors.outlineVariant,
          texto: colors.onSurface,
          textoSecundario: colors.onSurfaceVariant,
        );
    }
  }
}

class _EstiloCita {
  final Color fondo;
  final Color borde;
  final Color texto;
  final Color textoSecundario;

  _EstiloCita({
    required this.fondo,
    required this.borde,
    required this.texto,
    required this.textoSecundario,
  });
}

class _GuardiaLeyenda extends StatelessWidget {
  final bool isWide;

  const _GuardiaLeyenda({
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          _LeyendaItem(
            color: colors.primaryContainer,
            texto: 'Mantenimiento',
          ),
          _LeyendaItem(
            color: colors.secondaryContainer,
            texto: 'Reparación',
          ),
          _LeyendaItem(
            color: colors.tertiaryContainer,
            texto: 'Servicio rápido',
          ),
          _LeyendaItem(
            color: colors.error,
            texto: 'No llegó',
            textColor: colors.onError,
          ),
          _LeyendaItem(
            color: colors.errorContainer,
            texto: 'Cancelado',
            textColor: colors.onErrorContainer,
          ),
        ],
      ),
    );
  }
}

class _LeyendaItem extends StatelessWidget {
  final Color color;
  final String texto;
  final Color? textColor;

  const _LeyendaItem({
    required this.color,
    required this.texto,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isWide ? 22 : 18,
          height: isWide ? 22 : 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: colors.outlineVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: TextStyle(
            color: textColor ?? colors.onSurface,
            fontSize: isWide ? 15 : 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _GuardiaFooter extends StatelessWidget {
  const _GuardiaFooter();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          'Automotores Continental',
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}