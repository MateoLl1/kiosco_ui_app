
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiosco_au/presentation/providers/providers.dart';


class ConfigScreen extends ConsumerStatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConsumerState<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends ConsumerState<ConfigScreen> {

  void loadConfig() async {
    await ref.read(agenciaProvider.notifier).loadAgencias();
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  @override
  Widget build(BuildContext context) {
    final agencias = ref.watch(agenciaProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agencias'),
      ),
      body: ListView.builder(
        itemCount: agencias.length,
        itemBuilder: (context, index) {
          final agencia = agencias[index];
          return ListTile(
            title: Text(agencia.agNombre),
          );
        },
      ),
    );
  }
}