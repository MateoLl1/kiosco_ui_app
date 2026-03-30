
import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String message;

  const EmptyCard({
    super.key, 
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}