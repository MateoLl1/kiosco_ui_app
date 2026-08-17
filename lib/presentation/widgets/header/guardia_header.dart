import 'package:flutter/material.dart';

class GuardiaHeader extends StatefulWidget {
  final String? agenciaNombre;
  final Future<void> Function()? onRefresh;

  const GuardiaHeader({
    super.key,
    required this.agenciaNombre,
    this.onRefresh,
  });

  @override
  State<GuardiaHeader> createState() => _GuardiaHeaderState();
}

class _GuardiaHeaderState extends State<GuardiaHeader> {
  bool _cargando = false;

  Future<void> _recargar() async {
    if (_cargando || widget.onRefresh == null) return;
    setState(() => _cargando = true);
    try {
      await widget.onRefresh!();
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isWide ? 24 : 16,
        12,
        isWide ? 24 : 16,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.agenciaNombre ?? 'Guardia',
                  style: TextStyle(
                    fontSize: isWide ? 32 : 24,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (widget.onRefresh != null) ...[
            const SizedBox(width: 12),
            // Botón explícito en vez de gesto de swipe: el swipe-to-refresh
            // es dificil de descubrir y de ejecutar para usuarios mayores.
            _cargando
                ? SizedBox(
                    width: isWide ? 52 : 48,
                    height: isWide ? 52 : 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: colors.primary,
                    ),
                  )
                : FilledButton.tonalIcon(
                    onPressed: _recargar,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Actualizar'),
                    style: FilledButton.styleFrom(
                      minimumSize: Size(0, isWide ? 52 : 48),
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 20 : 16,
                      ),
                      textStyle: TextStyle(
                        fontSize: isWide ? 16 : 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ],
        ],
      ),
    );
  }
}