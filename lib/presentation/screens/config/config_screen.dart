import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/footer/ac_footer.dart';

class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {
  Agencia? agenciaSeleccionada;
  String? tipoSeleccionado;

  final List<String> tiposDispositivo = [
    'guardia',
    'turnero',
    'kiosco',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(agenciaProvider.notifier).loadAgencias();
    });
  }

  @override
  Widget build(BuildContext context) {
    final agencias = ref.watch(agenciaProvider);
    final isWide = MediaQuery.of(context).size.width >= 900;
    final colors = Theme.of(context).colorScheme;
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

          agencias.isNotEmpty ? SafeArea(
            child: Center(
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
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Selecciona la agencia y el tipo de dispositivo.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Agencia',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<Agencia>(
                                    value: agenciaSeleccionada,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      hintText: 'Selecciona una agencia',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                    items: agencias.map((agencia) {
                                      return DropdownMenuItem<Agencia>(
                                        value: agencia,
                                        child: Text(
                                          agencia.agNombre,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        agenciaSeleccionada = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Tipo de dispositivo',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: tipoSeleccionado,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Selecciona el tipo de equipo',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                    items: tiposDispositivo.map((tipo) {
                                      return DropdownMenuItem<String>(
                                        value: tipo,
                                        child: Text(
                                          tipo,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        tipoSeleccionado = value;
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
                              onPressed: () {},
                              child: const Text('Continuar'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AcFooter()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ): Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}