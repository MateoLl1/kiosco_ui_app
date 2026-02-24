import 'package:flutter/material.dart';

class HomeOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const HomeOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fgColor = foregroundColor ?? theme.colorScheme.onSurface;

    return SizedBox(
      height: 180,
      child: Card(
        elevation: 1,
        color: bgColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 42, color: fgColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: fgColor,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: fgColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}