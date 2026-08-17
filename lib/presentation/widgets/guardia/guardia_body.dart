import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaBody extends ConsumerStatefulWidget {
  final AsyncValue<List<Cita>> state;
  final Future<void> Function() onRefresh;
  final String mensajeVacio;

  const GuardiaBody({
    super.key,
    required this.state,
    required this.onRefresh,
    this.mensajeVacio = 'No hay citas disponibles',
  });

  @override
  ConsumerState<GuardiaBody> createState() => _GuardiaBodyState();
}

class _GuardiaBodyState extends ConsumerState<GuardiaBody> {
  // Compartido entre el Scrollbar y el SingleChildScrollView para que la
  // barra visible refleje y controle el mismo desplazamiento horizontal.
  final _scrollHorizontal = ScrollController();

  @override
  void dispose() {
    _scrollHorizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return widget.state.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                widget.mensajeVacio,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }

        final isWide = MediaQuery.of(context).size.width >= 900;

        // Columnas de ancho fijo (ver GuardiaTablaColumnas): el texto nunca
        // se aprieta ni se parte en dos líneas. Si la tabla no entra en la
        // pantalla, se desplaza lateralmente en vez de comprimirse — la
        // barra queda siempre visible para que sea evidente que hay más.
        return Scrollbar(
          controller: _scrollHorizontal,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollHorizontal,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: GuardiaTablaColumnas.anchoFila(isWide),
              child: Column(
                children: [
                  const GuardiaTablaHeader(),
                  const SizedBox(height: 8),
                  ...List.generate(citas.length, (index) {
                    final cita = citas[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: index == citas.length - 1 ? 0 : 8),
                      child: CitaTitle(
                        cita: cita,
                        onTap: () => ejecutarAccionCitaGuardia(
                          context: context,
                          ref: ref,
                          cita: cita,
                          onRefresh: widget.onRefresh,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
