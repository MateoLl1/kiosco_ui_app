import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TurneroHeader extends StatelessWidget {
  final DateTime now;

  const TurneroHeader({
    super.key,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final time = DateFormat('hh:mm:ss a', 'es').format(now).toLowerCase();
    final date =
        _capitalize(DateFormat("EEEE, d 'de' MMMM 'de' y", 'es').format(now));

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(
            color: colors.outline.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.desktop_windows_outlined,
            color: colors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'AUTOMOTORES CONTINENTAL',
            style: TextStyle(
              color: colors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}