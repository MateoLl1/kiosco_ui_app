import 'package:flutter/material.dart';

class AcFooter extends StatelessWidget {
  const AcFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Column(
        children: [

          Image.asset(
            'assets/img/chevrolet-logo.png',
            width: 100,
          ),
          Divider(
            endIndent: 50,
            indent: 50,
          ),

          const Text(
            'Automotores Continental',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}