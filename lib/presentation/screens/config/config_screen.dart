import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  int? agenciaSeleccionadaId;
  AppRole? rolSeleccionado;
  bool guardando = false;

  List<AppRole> get rolesDisponibles => AppRole.values;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(agenciaProvider.notifier).loadAgencias();
      await ref.read(appSessionProvider.notifier).loadSession();

      final session = ref.read(appSessionProvider);

      if (!mounted || session == null) return;

      setState(() {
        agenciaSeleccionadaId = session.agenciaId;
        rolSeleccionado = session.role;
      });
    });
  }

  bool get puedeContinuar =>
      !guardando && agenciaSeleccionadaId != null && rolSeleccionado != null;

  String _getRoleLabel(AppRole role) {
    switch (role) {
      case AppRole.guardia:
        return 'Guardia';
      case AppRole.kiosco:
        return 'Kiosco';
      case AppRole.turnero:
        return 'Turnero';
      case AppRole.mostrador:
        return 'Mostrador';
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }

  Agencia? _obtenerAgenciaSeleccionada(List<Agencia> agencias) {
    final id = agenciaSeleccionadaId;

    if (id == null) return null;

    final coincidencias = agencias.where((x) => x.agCodigo == id).toList();

    if (coincidencias.length != 1) return null;

    return coincidencias.first;
  }

  List<DropdownMenuItem<int>> _crearItemsAgencias(List<Agencia> agencias) {
    final idsUsados = <int>{};
    final items = <DropdownMenuItem<int>>[];

    for (final agencia in agencias) {
      if (idsUsados.contains(agencia.agCodigo)) continue;

      idsUsados.add(agencia.agCodigo);

      items.add(
        DropdownMenuItem<int>(
          value: agencia.agCodigo,
          child: Text(
            agencia.agNombre,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return items;
  }

  Future<void> _continuar() async {
    if (!puedeContinuar) return;

    final agencias = ref.read(agenciaProvider);
    final agencia = _obtenerAgenciaSeleccionada(agencias);
    final rol = rolSeleccionado;

    if (agencia == null || rol == null) return;

    setState(() {
      guardando = true;
    });

    try {
      await ref.read(appSessionProvider.notifier).saveSession(
            agenciaId: agencia.agCodigo,
            agenciaNombre: agencia.agNombre,
            role: rol,
          );

      if (!mounted) return;

      switch (rol) {
        case AppRole.guardia:
          context.go('/guardia');
          break;
        case AppRole.kiosco:
          context.go('/ingresar-ruc');
          break;
        case AppRole.turnero:
          context.go('/pantalla-turnos');
          break;
        case AppRole.mostrador:
          context.go('/mostrador');
          break;
      }
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final agencias = ref.watch(agenciaProvider);
    final isWide = MediaQuery.of(context).size.width >= 900;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final agenciaSeleccionada = _obtenerAgenciaSeleccionada(agencias);
    final agenciaItems = _crearItemsAgencias(agencias);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: ConfigBackgroundPainter(
                colorFondo: colors.surface,
                colorCirculoInferior: colors.primary,
                colorCirculoSuperior: colors.secondary,
              ),
            ),
          ),
          SafeArea(
            child: agencias.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isWide ? 700 : 500,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Configuración inicial',
                                  textAlign: TextAlign.center,
                                  style: textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Selecciona la agencia y el rol con el que se comportará la aplicación.',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 24),
                                Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Agencia',
                                          style: textTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<int>(
                                          initialValue:
                                              agenciaSeleccionada?.agCodigo,
                                          isExpanded: true,
                                          decoration: _inputDecoration(
                                            'Selecciona una agencia',
                                          ),
                                          items: agenciaItems,
                                          onChanged: guardando
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    agenciaSeleccionadaId =
                                                        value;
                                                  });
                                                },
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Rol de la aplicación',
                                          style: textTheme.titleSmall,
                                        ),
                                        const SizedBox(height: 8),
                                        DropdownButtonFormField<AppRole>(
                                          initialValue: rolSeleccionado,
                                          isExpanded: true,
                                          decoration: _inputDecoration(
                                            'Selecciona un rol',
                                          ),
                                          items: rolesDisponibles.map((role) {
                                            return DropdownMenuItem<AppRole>(
                                              value: role,
                                              child: Text(
                                                _getRoleLabel(role),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: guardando
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    rolSeleccionado = value;
                                                  });
                                                },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 54,
                                  child: FilledButton(
                                    onPressed:
                                        puedeContinuar ? _continuar : null,
                                    child: guardando
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                            ),
                                          )
                                        : const Text('Continuar'),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const AcFooter(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}