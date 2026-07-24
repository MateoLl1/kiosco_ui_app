import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class IngresarPlacaScreen extends ConsumerStatefulWidget {
  const IngresarPlacaScreen({super.key});

  @override
  ConsumerState<IngresarPlacaScreen> createState() =>
      _IngresarPlacaScreenState();
}

class _IngresarPlacaScreenState extends ConsumerState<IngresarPlacaScreen> {
  final List<String> _caracteres = [];
  bool _consultando = false;

  static const int _maxLongitud = 7;

  static bool get _soportaTeclado =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;

  final List<List<String>> _filasLetras = const [
    ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'],
    ['J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'],
    ['S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
  ];

  final List<List<String>> _filasNumeros = const [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  void _agregarCaracter(String valor) {
    if (_caracteres.length >= _maxLongitud || _consultando) return;

    final esLetra = RegExp(r'^[A-Z]$').hasMatch(valor);
    final esNumero = RegExp(r'^[0-9]$').hasMatch(valor);

    if (_caracteres.length < 3) {
      if (!esLetra) return;
    } else {
      if (!esNumero) return;
    }

    setState(() => _caracteres.add(valor));
  }

  void _borrarUltimo() {
    if (_caracteres.isEmpty || _consultando) return;
    setState(() => _caracteres.removeLast());
  }

  void _borrarTodo() {
    if (_caracteres.isEmpty || _consultando) return;
    setState(() => _caracteres.clear());
  }

  String get _placaIngresada => _caracteres.join().toUpperCase();

  bool get _placaValida {
    return RegExp(r'^[A-Z]{3}[0-9]{4}$').hasMatch(_placaIngresada);
  }

  String get _placaMostrada {
    if (_caracteres.isEmpty) return 'ABC-1234';
    final placa = _placaIngresada;
    if (placa.length <= 3) return placa;
    return '${placa.substring(0, 3)}-${placa.substring(3)}';
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    // Letras A-Z
    final label = key.keyLabel;
    if (label.length == 1) {
      final upper = label.toUpperCase();
      if (RegExp(r'^[A-Z0-9]$').hasMatch(upper)) {
        _agregarCaracter(upper);
        return KeyEventResult.handled;
      }
    }

    if (key == LogicalKeyboardKey.backspace) {
      _borrarUltimo();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.delete) {
      _borrarTodo();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _buscarCita();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _buscarCita() async {
    if (!_placaValida || _consultando) return;

    final session = ref.read(appSessionProvider);
    final agenciaId = session?.agenciaId ?? 0;

    setState(() => _consultando = true);

    try {
      final cliente = await ref
          .read(clienteSiacProvider.notifier)
          .consultarClientePorPlaca(placa: _placaIngresada);

      _borrarTodo();
      if (!mounted) return;

      if (cliente != null && cliente.identificacion.trim().isNotEmpty) {
        if (agenciaId > 0) {
          final turnoActual = await ref
              .read(kioscoRepositoryProvider)
              .obtenerTurnoPorIdentificacion(
                identificacion: cliente.identificacion.trim(),
                agenciaId: agenciaId,
              );

          if (!mounted) return;

          if (turnoActual != null) {
            context.go('/turno-asignado', extra: turnoActual);
            return;
          }
        }
      }

      context.go('/bienvenida-usuario');
    } catch (_) {
      ref.read(clienteSiacProvider.notifier).limpiar();
      _borrarTodo();
      if (!mounted) return;
      context.go('/bienvenida-usuario');
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final ancho = MediaQuery.of(context).size.width;
    final esAncho = ancho >= 900;

    final content = KioskIdleDetector(
      paused: _consultando,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: Home2Painter(
                    primaryColor:
                        Theme.of(context).extension<AppSeedColorTheme>()?.seed ??
                            colores.primary,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: ReturnPageButton(),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: esAncho ? 720 : 560),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: esAncho ? 36 : 20,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ingrese su placa',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Text(
                              'Digite la placa de su vehículo para consultar su cita',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: colores.onSurfaceVariant),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: colores.surfaceContainerHighest
                                  .withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              _placaMostrada,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 4,
                                    color: _caracteres.isEmpty
                                        ? colores.onSurfaceVariant
                                            .withValues(alpha: 0.40)
                                        : colores.onSurface,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              const columnasMaximas = 9;
                              const separacion = 8.0;

                              final anchoTecla =
                                  (constraints.maxWidth -
                                          (separacion * (columnasMaximas - 1))) /
                                      columnasMaximas;

                              final anchoTeclaTriple =
                                  anchoTecla * 3 + separacion * 2;

                              Widget filaLetras(List<String> fila) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < fila.length; i++) ...[
                                      SizedBox(
                                        width: anchoTecla,
                                        child: BotonTeclado(
                                          texto: fila[i],
                                          onTap: _consultando
                                              ? null
                                              : () => _agregarCaracter(fila[i]),
                                        ),
                                      ),
                                      if (i < fila.length - 1)
                                        const SizedBox(width: separacion),
                                    ],
                                  ],
                                );
                              }

                              Widget filaNumeros(List<String> fila) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    for (int i = 0; i < fila.length; i++) ...[
                                      SizedBox(
                                        width: anchoTeclaTriple,
                                        child: BotonTeclado(
                                          texto: fila[i],
                                          onTap: _consultando
                                              ? null
                                              : () => _agregarCaracter(fila[i]),
                                        ),
                                      ),
                                      if (i < fila.length - 1)
                                        const SizedBox(width: separacion),
                                    ],
                                  ],
                                );
                              }

                              return Column(
                                children: [
                                  for (final fila in _filasLetras) ...[
                                    filaLetras(fila),
                                    const SizedBox(height: 8),
                                  ],
                                  for (final fila in _filasNumeros) ...[
                                    filaNumeros(fila),
                                    const SizedBox(height: 8),
                                  ],
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: anchoTeclaTriple,
                                        child: BotonTeclado(
                                          texto: 'Borrar',
                                          onTap: _caracteres.isNotEmpty &&
                                                  !_consultando
                                              ? _borrarTodo
                                              : null,
                                          colorFondo: colores.errorContainer,
                                          colorTexto: colores.onErrorContainer,
                                        ),
                                      ),
                                      const SizedBox(width: separacion),
                                      SizedBox(
                                        width: anchoTeclaTriple,
                                        child: BotonTeclado(
                                          texto: '0',
                                          onTap: _consultando
                                              ? null
                                              : () => _agregarCaracter('0'),
                                        ),
                                      ),
                                      const SizedBox(width: separacion),
                                      SizedBox(
                                        width: anchoTeclaTriple,
                                        child: BotonTeclado(
                                          texto: '',
                                          onTap: _caracteres.isNotEmpty &&
                                                  !_consultando
                                              ? _borrarUltimo
                                              : null,
                                          icono: Icons.backspace_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          if (_placaValida) ...[
                            const SizedBox(height: 18),
                            FadeIn(
                              child: CustomIconTextButton(
                                texto: _consultando
                                    ? 'Consultando...'
                                    : 'Continuar',
                                icono: _consultando
                                    ? Icons.hourglass_top_rounded
                                    : Icons.arrow_forward_rounded,
                                onTap: _consultando ? null : _buscarCita,
                                colorFondo: colores.primary,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: _consultando
                                ? null
                                : () => context.go('/ingresar-ruc'),
                            icon: const Icon(Icons.badge_outlined, size: 18),
                            label: const Text('Buscar por Cédula / RUC'),
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
      ),
    );

    if (!_soportaTeclado) return content;
    return Focus(autofocus: true, onKeyEvent: _onKeyEvent, child: content);
  }
}
