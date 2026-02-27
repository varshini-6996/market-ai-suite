import 'package:flutter/material.dart';

class LeadScreen extends StatelessWidget {
  const LeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lead Screen')),
      body: const Center(child: Text('Lead UI here')),
    );
  }
}