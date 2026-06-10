import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';

class IngresarRucScreen extends ConsumerStatefulWidget {
  const IngresarRucScreen({super.key});

  @override
  ConsumerState<IngresarRucScreen> createState() => _IngresarRucScreenState();
}

class _IngresarRucScreenState extends ConsumerState<IngresarRucScreen> {
  final List<String> _digitos = [];
  bool _consultando = false;

  static const int _maxLongitud = 13;

  void _agregarDigito(String valor) {
    if (_digitos.length >= _maxLongitud || _consultando) return;

    setState(() {
      _digitos.add(valor);
    });
  }

  void _borrarUltimo() {
    if (_digitos.isEmpty || _consultando) return;

    setState(() {
      _digitos.removeLast();
    });
  }

  void _borrarTodo() {
    if (_digitos.isEmpty || _consultando) return;

    setState(() {
      _digitos.clear();
    });
  }

  String get _identificacionIngresada => _digitos.join();

  bool get _cedulaValida {
    final cedula = _identificacionIngresada;
    return RegExp(r'^[0-9]{10}$').hasMatch(cedula);
  }

  bool get _rucValido {
    final ruc = _identificacionIngresada;
    return RegExp(r'^[0-9]{13}$').hasMatch(ruc);
  }

  bool get _cedulaORucValido => _cedulaValida || _rucValido;

  Future<void> _continuar() async {
    if (!_cedulaORucValido || _consultando) return;

    final session = ref.read(appSessionProvider);
    final agenciaId = session?.agenciaId ?? 0;

    if (agenciaId <= 0) {
      _borrarTodo();

      if (!mounted) return;
      context.go('/bienvenida-usuario');
      return;
    }

    final identificacion = _identificacionIngresada;

    setState(() {
      _consultando = true;
    });

    try {
      final cliente = await ref
          .read(clienteSiacProvider.notifier)
          .consultarCliente(identificacion: identificacion, agenciaId: agenciaId);

      if (cliente != null && cliente.identificacion.trim().isNotEmpty) {
        final turnoActual = await ref
            .read(kioscoRepositoryProvider)
            .obtenerTurnoPorIdentificacion(
              identificacion: cliente.identificacion.trim(),
              agenciaId: agenciaId,
            );

        if (turnoActual != null) {
          _borrarTodo();

          if (!mounted) return;
          context.go('/turno-asignado', extra: turnoActual);
          return;
        }
      }

      _borrarTodo();

      if (!mounted) return;
      context.go('/bienvenida-usuario');
    } catch (e) {
      ref.read(clienteSiacProvider.notifier).limpiar();

      _borrarTodo();

      if (!mounted) return;
      context.go('/bienvenida-usuario');
    } finally {
      if (mounted) {
        setState(() {
          _consultando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final ancho = MediaQuery.of(context).size.width;
    final esAncho = ancho >= 900;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: Home2Painter(primaryColor: colores.primary),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: esAncho ? 720 : 560),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: esAncho ? 36 : 20,
                      vertical: 24,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Bienvenido',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingrese su Cédula / RUC para comenzar',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: colores.onSurfaceVariant),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: colores.surfaceContainerHighest.withValues(
                              alpha: 0.55,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _digitos.isEmpty
                                ? '0000000000000'
                                : _identificacionIngresada,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 4,
                                  color: _digitos.isEmpty
                                      ? colores.onSurfaceVariant.withValues(
                                          alpha: 0.40,
                                        )
                                      : colores.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, cons) {
                            const separacion = 12.0;
                            final anchoTotal = cons.maxWidth;
                            final anchoTecla =
                                (anchoTotal - separacion * 2) / 3;

                            Widget fila(List<String> valores) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < valores.length; i++) ...[
                                    SizedBox(
                                      width: anchoTecla,
                                      child: BotonTeclado(
                                        texto: valores[i],
                                        onTap: _consultando
                                            ? null
                                            : () => _agregarDigito(valores[i]),
                                      ),
                                    ),
                                    if (i < valores.length - 1)
                                      const SizedBox(width: separacion),
                                  ],
                                ],
                              );
                            }

                            return Column(
                              children: [
                                fila(const ['1', '2', '3']),
                                const SizedBox(height: 12),
                                fila(const ['4', '5', '6']),
                                const SizedBox(height: 12),
                                fila(const ['7', '8', '9']),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: anchoTecla,
                                      child: BotonTeclado(
                                        texto: 'Borrar',
                                        onTap:
                                            _digitos.isNotEmpty && !_consultando
                                            ? _borrarTodo
                                            : null,
                                        colorFondo: colores.errorContainer,
                                        colorTexto: colores.onErrorContainer,
                                      ),
                                    ),
                                    const SizedBox(width: separacion),
                                    SizedBox(
                                      width: anchoTecla,
                                      child: BotonTeclado(
                                        texto: '0',
                                        onTap: _consultando
                                            ? null
                                            : () => _agregarDigito('0'),
                                      ),
                                    ),
                                    const SizedBox(width: separacion),
                                    SizedBox(
                                      width: anchoTecla,
                                      child: BotonTeclado(
                                        texto: '',
                                        onTap:
                                            _digitos.isNotEmpty && !_consultando
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
                        if (_cedulaORucValido) ...[
                          const SizedBox(height: 18),
                          FadeIn(
                            child: CustomIconTextButton(
                              texto: _consultando
                                  ? 'Consultando...'
                                  : 'Continuar',
                              icono: _consultando
                                  ? Icons.hourglass_top_rounded
                                  : Icons.arrow_forward_rounded,
                              onTap: _consultando ? null : _continuar,
                              colorFondo: colores.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}