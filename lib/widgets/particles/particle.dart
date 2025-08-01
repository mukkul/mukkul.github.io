import 'package:flutter/material.dart';

class ParticleWidget extends StatelessWidget {
  const ParticleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
    );
  }
}