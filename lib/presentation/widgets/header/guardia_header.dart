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
                if (!isWide) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.swipe_up_rounded,
                        size: 13,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Desliza hacia abajo para actualizar',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isWide && widget.onRefresh != null)
            _cargando
                ? SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: colors.primary,
                    ),
                  )
                : IconButton(
                    onPressed: _recargar,
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'Actualizar',
                    color: colors.primary,
                    iconSize: 28,
                  ),
        ],
      ),
    );
  }
}