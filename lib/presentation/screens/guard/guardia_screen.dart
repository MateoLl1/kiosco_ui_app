import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaScreen extends ConsumerStatefulWidget {
  const GuardiaScreen({super.key});

  @override
  ConsumerState<GuardiaScreen> createState() => _GuardiaScreenState();
}

class _GuardiaScreenState extends ConsumerState<GuardiaScreen> {
  final _buscarController = TextEditingController();
  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(_cargarCitas);
  }

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }

  Future<void> _cargarCitas() async {
    await ref.read(citasGuardiaProvider.notifier).loadCitas();
  }

  void _onBuscarChanged(String value) {
    setState(() => _busqueda = value.trim());
  }

  void _limpiarBusqueda() {
    _buscarController.clear();
    setState(() => _busqueda = '');
  }

  Future<void> _generarSinCita() async {
    await generarTurnoSinCitaGuardia(
      context: context,
      ref: ref,
    );
  }

  Future<void> _generarSinCitaFlotas() async {
    await generarTurnoSinCitaFlotasGuardia(
      context: context,
      ref: ref,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionProvider);
    final state = ref.watch(citasGuardiaProvider);
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    final busqueda = _busqueda.toUpperCase();
    final stateFiltrado = busqueda.isEmpty
        ? state
        : state.whenData(
            (citas) => citas
                .where((c) => c.placa.toUpperCase().contains(busqueda))
                .toList(),
          );

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: isWide ? 12 : 8),
            child: Column(
              children: [
                GuardiaHeader(
                  agenciaNombre: session?.agenciaNombre,
                  onRefresh: _cargarCitas,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
                  child: GuardiaAcciones(
                    isWide: isWide,
                    onSinCita: _generarSinCita,
                    onSinCitaFlotas: _generarSinCitaFlotas,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
                  child: GuardiaBuscadorPlaca(
                    controller: _buscarController,
                    onChanged: _onBuscarChanged,
                    onClear: _limpiarBusqueda,
                    isWide: isWide,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
                  child: GuardiaBody(
                    state: stateFiltrado,
                    onRefresh: _cargarCitas,
                    mensajeVacio: _busqueda.isEmpty
                        ? 'No hay citas disponibles'
                        : 'No se encontraron citas con la placa "$_busqueda"',
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
                  child: GuardiaLeyenda(isWide: isWide),
                ),
                const SizedBox(height: 12),
                const AcFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}