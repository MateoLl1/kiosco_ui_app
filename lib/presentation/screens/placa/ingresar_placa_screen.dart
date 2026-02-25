import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class IngresarPlacaScreen extends StatefulWidget {
  const IngresarPlacaScreen({super.key});

  @override
  State<IngresarPlacaScreen> createState() => _IngresarPlacaScreenState();
}

class _IngresarPlacaScreenState extends State<IngresarPlacaScreen> {
  final List<String> _caracteres = [];

  static const int _maxLongitud = 7;

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
    if (_caracteres.length >= _maxLongitud) return;

    final esLetra = RegExp(r'^[A-Z]$').hasMatch(valor);
    final esNumero = RegExp(r'^[0-9]$').hasMatch(valor);

    if (_caracteres.length < 3) {
      if (!esLetra) return;
      setState(() {
        _caracteres.add(valor);
      });
      return;
    }

    if (!esNumero) return;

    setState(() {
      _caracteres.add(valor);
    });
  }

  void _borrarUltimo() {
    if (_caracteres.isEmpty) return;
    setState(() {
      _caracteres.removeLast();
    });
  }

  void _borrarTodo() {
    if (_caracteres.isEmpty) return;
    setState(() {
      _caracteres.clear();
    });
  }

  String get _placaIngresada {
    return _caracteres.join().toUpperCase();
  }

  String get _placaParaBackend {
    return _placaIngresada;
  }

  bool get _placaCompletaValida {
    final placa = _placaParaBackend;
    final regex = RegExp(r'^[A-Z]{3}[0-9]{4}$');
    return regex.hasMatch(placa);
  }

  String get _placaMostrada {
    if (_caracteres.isEmpty) return 'ABC-1234';

    final placa = _placaIngresada;

    if (placa.length <= 3) return placa;

    final parteLetras = placa.substring(0, 3);
    final parteNumeros = placa.substring(3);

    return '$parteLetras-$parteNumeros';
  }

  bool get _puedeBorrar => _caracteres.isNotEmpty;

  void _buscarCita() {
    if (!_placaCompletaValida) return;
    final placa = _placaParaBackend;


    mostrarAlerta(
      context, 
      icono: Icons.info, 
      colorIcono: Theme.of(context).colorScheme.primary, 
      titulo: 'Sin cita registrada', 
      mensaje: 'No se encontró cita para la placa $placa', 
      textoBoton: 'Generar turno',
      onBoton: () => {
        _borrarTodo(),
        context.pushReplacement('/ingresar-ruc')
      }
    );

    // context.go('/');
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
            Positioned(
              top: 16,
              left: 16,
              child: Material(
                color: colores.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: esAncho ? 720 : 560),
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
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Text(
                          'Digite la placa de su vehículo para consultar su cita',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
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
                          color: colores.surfaceContainerHighest.withValues(
                            alpha: 0.55,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _placaMostrada,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 4,
                                color: _caracteres.isEmpty
                                    ? colores.onSurfaceVariant.withValues(
                                        alpha: 0.40,
                                      )
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
                                      onTap: () => _agregarCaracter(fila[i]),
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
                                      onTap: () => _agregarCaracter(fila[i]),
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
                                      onTap: _puedeBorrar ? _borrarTodo : null,
                                      colorFondo: colores.errorContainer,
                                      colorTexto: colores.onErrorContainer,
                                    ),
                                  ),
                                  const SizedBox(width: separacion),
                                  SizedBox(
                                    width: anchoTeclaTriple,
                                    child: BotonTeclado(
                                      texto: '0',
                                      onTap: () => _agregarCaracter('0'),
                                    ),
                                  ),
                                  const SizedBox(width: separacion),
                                  SizedBox(
                                    width: anchoTeclaTriple,
                                    child: BotonTeclado(
                                      texto: '',
                                      onTap:
                                          _puedeBorrar ? _borrarUltimo : null,
                                      icono: Icons.close_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      if (_placaCompletaValida) ...[
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: FadeIn(
                            child: CustomIconTextButton(
                              texto: 'Buscar cita',
                              icono: Icons.search_rounded,
                              onTap: _buscarCita,
                              colorFondo: colores.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
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