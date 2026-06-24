

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/config/config.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';


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
  late final TextEditingController _numeroController;
  bool _mostrarFormulario = false;
  bool _enviando = false;
  bool _enviado = false;
  String? _mensajeError;
  String? _mensajeOk;

  @override
  void initState() {
    super.initState();

    _numeroController = TextEditingController(
      text: AppValidators.normalizarTelefono(widget.numeroInicial),
    );
  }

  @override
  void dispose() {
    _numeroController.dispose();
    super.dispose();
  }

  bool _numeroValido(String numero) =>
      AppValidators.telefonoEcuatoriano(numero);

  Future<void> _enviarWhatsapp() async {
    if (_enviando || _enviado) return;

    final numero = _numeroController.text.trim();

    setState(() {
      _mensajeError = null;
      _mensajeOk = null;
    });

    if (!_numeroValido(numero)) {
      setState(() {
        _mensajeError = 'Ingrese un número válido. Ej: 0988931581 o 998931581.';
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

    return Card(
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
              OutlinedButton.icon(
                onPressed: _enviado
                    ? null
                    : () {
                        setState(() {
                          _mostrarFormulario = true;
                        });
                      },
                icon: const Icon(Icons.chat_outlined),
                label: Text(
                  _enviado
                      ? 'WhatsApp enviado'
                      : 'Enviar turno por WhatsApp',
                ),
              ),
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
                'Puede usar el número registrado o ingresar otro número de Ecuador.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _numeroController,
                enabled: !_enviando && !_enviado,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Número de WhatsApp',
                  hintText: '0988931581 o 998931581',
                  counterText: '',
                  prefixIcon: const Icon(Icons.phone_android),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
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
              if (!_enviado) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _enviando
                      ? null
                      : () {
                          setState(() {
                            _mostrarFormulario = false;
                            _mensajeError = null;
                            _mensajeOk = null;
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
  }
}