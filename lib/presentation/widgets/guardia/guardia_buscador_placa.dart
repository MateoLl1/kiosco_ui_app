import 'package:flutter/material.dart';

class GuardiaBuscadorPlaca extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool isWide;

  const GuardiaBuscadorPlaca({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fontSize = isWide ? 18.0 : 16.0;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textCapitalization: TextCapitalization.characters,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar por placa',
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: colors.onSurfaceVariant,
        ),
        prefixIcon: Icon(Icons.search_rounded, size: isWide ? 26 : 24),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Limpiar búsqueda',
              onPressed: onClear,
            );
          },
        ),
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isWide ? 16 : 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
    );
  }
}
