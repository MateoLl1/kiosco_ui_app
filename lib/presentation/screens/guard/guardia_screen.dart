import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';
import 'package:kiosco_au/presentation/widgets/widgets.dart';

class GuardiaScreen extends ConsumerStatefulWidget {
  const GuardiaScreen({super.key});

  @override
  ConsumerState<GuardiaScreen> createState() => _GuardiaScreenState();
}

class _GuardiaScreenState extends ConsumerState<GuardiaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_cargarCitas);
  }

  Future<void> _cargarCitas() async {
    await ref.read(citasGuardiaProvider.notifier).loadCitas();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionProvider);
    final state = ref.watch(citasGuardiaProvider);
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            GuardiaHeader(
              agenciaNombre: session?.agenciaNombre,
              onActualizar: _cargarCitas,
              cargando: state.isLoading,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
              child: GuardiaAcciones(
                isWide: isWide,
                onSinCita: () {
                  // showModalBottomSheet(context: context, builder: (context) => const Placeholder());
                },
                onSinCitaFlotas: () {},
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
                child: GuardiaBody(
                  state: state,
                  onRefresh: _cargarCitas,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16),
              child: GuardiaLeyenda(isWide: isWide),
            ),
            const SizedBox(height: 12),
            const AcFooter()
          ],
        ),
      ),
    );
  }
}


