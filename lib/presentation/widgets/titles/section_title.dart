

import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({
    super.key, 
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleLarge,
        ),
      ],
    );
  }
}