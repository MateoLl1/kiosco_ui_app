import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiosco_au/domain/domain.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_bootstrap);
  }

  Future<void> _bootstrap() async {
    await ref.read(appSessionProvider.notifier).loadSession();

    final session = ref.read(appSessionProvider);

    if (!mounted) return;

    if (session == null) {
      context.go('/config');
      return;
    }

    final route = _routeByRole(session.role);
    context.go(route);
  }

  String _routeByRole(AppRole role) {
    switch (role) {
      case AppRole.turnero:
        return '/pantalla-turnos';
      case AppRole.kiosco:
        return '/';
      case AppRole.guardia:
        return '/taller-servicio';
      case AppRole.admin:
        return '/config';
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}