import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/screens/painters/painters.dart';

class BienvenidaUsuarioScreen extends ConsumerStatefulWidget {
  const BienvenidaUsuarioScreen({super.key});

  @override
  ConsumerState<BienvenidaUsuarioScreen> createState() =>
      _BienvenidaClienteScreenState();
}

class _BienvenidaClienteScreenState
    extends ConsumerState<BienvenidaUsuarioScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      context.go('/home');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final databook = ref.watch(databookProvider);
    final nombreCliente = databook?.sdNombre.trim() ?? '';
    final mostrarNombre = nombreCliente.isNotEmpty;

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 40,
                      ),
                      decoration: BoxDecoration(
                        color: colores.surface.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '¡Bienvenido!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: colores.onSurface,
                                ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            mostrarNombre ? nombreCliente : 'Estimado Cliente',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colores.primary,
                                ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Estamos listos para atenderle',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: colores.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
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