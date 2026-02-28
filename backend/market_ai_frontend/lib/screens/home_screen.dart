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
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 36, color: Colors.deepPurple),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.deepPurple,
  toolbarHeight: 80, // taller AppBar for more presence
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text(
        "Marketing Wizard",
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      SizedBox(height: 4),
      Text(
        "Your AI sidekick for marketing wins",
        style: TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400,
          fontFamily: 'Georgia',
          color: Colors.white70,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(0.5, 0.5),
              blurRadius: 1,
            ),
          ],
        ),
      ),
    ],
  ),
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
