import 'package:flutter/material.dart';

class PitchScreen extends StatelessWidget {
  const PitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pitch Screen')),
      body: const Center(child: Text('Pitch UI here')),
    );
  }
}