import 'package:flutter/material.dart';
import 'campaign_screen.dart';
import 'pitch_screen.dart';
import 'lead_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget buildCard(BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market AI"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard(context, "Campaign Generator", Icons.campaign, const CampaignScreen()),
            buildCard(context, "Sales Pitch", Icons.trending_up, const PitchScreen()),
            buildCard(context, "Lead Scoring", Icons.analytics, const LeadScreen()),
          ],
        ),
      ),
    );
  }
}