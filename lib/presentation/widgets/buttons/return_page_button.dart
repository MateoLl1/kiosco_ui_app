


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReturnPageButton extends StatelessWidget {
  const ReturnPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.pop(),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}