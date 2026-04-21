import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaBody extends StatelessWidget {
  final AsyncValue<List<Cita>> state;
  final Future<void> Function() onRefresh;

  const GuardiaBody({
    super.key,
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
            const GuardiaTablaHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: citas.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final cita = citas[index];

                    return CitaTile(
                      cita: cita,
                      onTap: () => _mostrarConfirmacion(context, cita),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarConfirmacion(BuildContext context, Cita cita) async {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isWide ? 28 : 20,
              20,
              isWide ? 28 : 20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Usted ha seleccionado el cliente:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: isWide ? 22 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  cita.nombreCliente.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: isWide ? 30 : 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Placa: ${cita.placa}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: isWide ? 18 : 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                if (isWide)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(58),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();


                            
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(58),
                          ),
                          child: const Text(
                            'Aceptar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                          ),
                          child: const Text(
                            'Aceptar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}