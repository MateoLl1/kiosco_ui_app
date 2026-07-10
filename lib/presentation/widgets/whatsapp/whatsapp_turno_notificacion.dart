

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/buttons/boton_teclado.dart';

class WhatsappTurnoNotificacion extends ConsumerStatefulWidget {
  final String numeroInicial;
  final String cliente;
  final String turno;
  final String area;

  const WhatsappTurnoNotificacion({
    super.key,
    required this.numeroInicial,
    required this.cliente,
    required this.turno,
    required this.area,
  });

  @override
  ConsumerState<WhatsappTurnoNotificacion> createState() =>
      _WhatsappTurnoNotificacionState();
}

class _WhatsappTurnoNotificacionState
    extends ConsumerState<WhatsappTurnoNotificacion> {
  static const int _maxLongitud = 10;

  static bool get _soportaTecladoFisico =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;

  static final Map<LogicalKeyboardKey, String> _digitMap = {
    LogicalKeyboardKey.digit0: '0',
    LogicalKeyboardKey.digit1: '1',
    LogicalKeyboardKey.digit2: '2',
    LogicalKeyboardKey.digit3: '3',
    LogicalKeyboardKey.digit4: '4',
    LogicalKeyboardKey.digit5: '5',
    LogicalKeyboardKey.digit6: '6',
    LogicalKeyboardKey.digit7: '7',
    LogicalKeyboardKey.digit8: '8',
    LogicalKeyboardKey.digit9: '9',
    LogicalKeyboardKey.numpad0: '0',
    LogicalKeyboardKey.numpad1: '1',
    LogicalKeyboardKey.numpad2: '2',
    LogicalKeyboardKey.numpad3: '3',
    LogicalKeyboardKey.numpad4: '4',
    LogicalKeyboardKey.numpad5: '5',
    LogicalKeyboardKey.numpad6: '6',
    LogicalKeyboardKey.numpad7: '7',
    LogicalKeyboardKey.numpad8: '8',
    LogicalKeyboardKey.numpad9: '9',
  };

  final List<String> _digitos = [];
  final FocusNode _focusNode = FocusNode();
  bool _mostrarFormulario = false;
  bool _enviando = false;
  bool _enviado = false;
  String? _mensajeError;
  String? _mensajeOk;
  late final List<String> _digitosOriginales;
  late final bool _numeroInicialValido;

  @override
  void initState() {
    super.initState();

    final numeroInicial = AppValidators.normalizarTelefono(
      widget.numeroInicial,
    );
    _numeroInicialValido = _numeroValido(numeroInicial);
    _digitosOriginales = _numeroInicialValido ? numeroInicial.split('') : [];
    _digitos.addAll(_digitosOriginales);
    _mostrarFormulario = !_numeroInicialValido;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _mostrarFormularioYEnfocar() {
    setState(() {
      _mostrarFormulario = true;
      _digitos.clear();
      _mensajeError = null;
      _mensajeOk = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  String get _numeroIngresado => _digitos.join();

  void _agregarDigito(String valor) {
    if (_enviando || _enviado) return;
    if (_digitos.length >= _maxLongitud) return;

    setState(() {
      _digitos.add(valor);
    });
  }

  void _borrarUltimo() {
    if (_enviando || _enviado || _digitos.isEmpty) return;

    setState(() {
      _digitos.removeLast();
    });
  }

  void _borrarTodo() {
    if (_enviando || _enviado || _digitos.isEmpty) return;

    setState(() {
      _digitos.clear();
    });
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_mostrarFormulario) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    final digito = _digitMap[key];
    if (digito != null) {
      _agregarDigito(digito);
      return KeyEventResult.handled;
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
      _enviarWhatsapp();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  bool _numeroValido(String numero) =>
      AppValidators.telefonoEcuatoriano(numero);

  Future<void> _enviarWhatsapp() async {
    if (_enviando || _enviado) return;

    final numero = _numeroIngresado.trim();

    setState(() {
      _mensajeError = null;
      _mensajeOk = null;
    });

    if (!_numeroValido(numero)) {
      setState(() {
        _mensajeError = 'Ingrese un número válido. Ej: 09889315812';
      });
      return;
    }

    setState(() {
      _enviando = true;
    });

    final request = NotificarTurnoWhatsappRequest(
      numeroEnvio: numero,
      cliente: widget.cliente,
      turno: widget.turno,
      area: widget.area,
    );

    final ok = await ref.read(kioscoRepositoryProvider).notificarTurnoWhatsapp(
          request: request,
        );

    if (!mounted) return;

    setState(() {
      _enviando = false;
      _enviado = ok;

      if (ok) {
        _mensajeOk = 'Notificación enviada correctamente.';
      } else {
        _mensajeError = 'No se pudo enviar la notificación. Intente nuevamente.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final card = Card(
      color: colors.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState: _mostrarFormulario
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿Desea recibir este turno por WhatsApp?',
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Le enviaremos el nombre, número de turno y área de atención.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone_android, color: colors.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Text(
                      _numeroIngresado,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              if (_mensajeError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _mensajeError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: _enviando || _enviado ? null : _enviarWhatsapp,
                icon: Icon(
                  _enviado
                      ? Icons.check_circle
                      : _enviando
                          ? Icons.hourglass_top
                          : Icons.chat_outlined,
                ),
                label: Text(
                  _enviado
                      ? 'WhatsApp enviado'
                      : _enviando
                          ? 'Enviando...'
                          : 'Enviar turno por WhatsApp',
                ),
              ),
              if (!_enviado) ...[
                const SizedBox(height: 4),
                TextButton(
                  onPressed: _enviando ? null : _mostrarFormularioYEnfocar,
                  child: const Text('Usar otro número'),
                ),
              ],
            ],
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enviar turno por WhatsApp',
                textAlign: TextAlign.center,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingrese el número de Ecuador al que desea enviar el turno.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone_android, color: colors.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _digitos.isEmpty ? '0' : _numeroIngresado,
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: _digitos.isEmpty
                              ? colors.onSurfaceVariant.withValues(alpha: 0.55)
                              : colors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, cons) {
                  const separacion = 8.0;
                  final anchoTecla = (cons.maxWidth - separacion * 2) / 3;

                  Widget fila(List<String> valores) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < valores.length; i++) ...[
                          SizedBox(
                            width: anchoTecla,
                            child: BotonTeclado(
                              texto: valores[i],
                              onTap: (_enviando || _enviado)
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
                      const SizedBox(height: 8),
                      fila(const ['4', '5', '6']),
                      const SizedBox(height: 8),
                      fila(const ['7', '8', '9']),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: anchoTecla,
                            child: BotonTeclado(
                              texto: 'Borrar',
                              onTap: (_digitos.isNotEmpty && !_enviando && !_enviado)
                                  ? _borrarTodo
                                  : null,
                              colorFondo: colors.errorContainer,
                              colorTexto: colors.onErrorContainer,
                            ),
                          ),
                          const SizedBox(width: separacion),
                          SizedBox(
                            width: anchoTecla,
                            child: BotonTeclado(
                              texto: '0',
                              onTap: (_enviando || _enviado)
                                  ? null
                                  : () => _agregarDigito('0'),
                            ),
                          ),
                          const SizedBox(width: separacion),
                          SizedBox(
                            width: anchoTecla,
                            child: BotonTeclado(
                              texto: '',
                              onTap: (_digitos.isNotEmpty && !_enviando && !_enviado)
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
              if (_mensajeError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _mensajeError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (_mensajeOk != null) ...[
                const SizedBox(height: 8),
                Text(
                  _mensajeOk!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _enviando || _enviado ? null : _enviarWhatsapp,
                icon: Icon(
                  _enviado
                      ? Icons.check_circle
                      : _enviando
                          ? Icons.hourglass_top
                          : Icons.send,
                ),
                label: Text(
                  _enviado
                      ? 'Notificación enviada'
                      : _enviando
                          ? 'Enviando...'
                          : 'Confirmar envío por WhatsApp',
                ),
              ),
              if (!_enviado && _numeroInicialValido) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _enviando
                      ? null
                      : () {
                          setState(() {
                            _mostrarFormulario = false;
                            _mensajeError = null;
                            _mensajeOk = null;
                            _digitos
                              ..clear()
                              ..addAll(_digitosOriginales);
                          });
                        },
                  child: const Text('No enviar'),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!_soportaTecladoFisico) return card;

    return Focus(focusNode: _focusNode, onKeyEvent: _onKeyEvent, child: card);
  }
}