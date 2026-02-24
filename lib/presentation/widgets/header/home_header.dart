import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: colors.primary
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}