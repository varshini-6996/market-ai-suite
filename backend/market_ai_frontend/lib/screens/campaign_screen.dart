import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  // Controllers
  final TextEditingController productController = TextEditingController();
  final TextEditingController audienceController = TextEditingController();
  final TextEditingController platformController = TextEditingController();

  final TextEditingController demandController = TextEditingController();

  String campaignResult = "";
  String demandResult = "";

  bool loadingCampaign = false;
  bool loadingDemand = false;

  // =========================
  // CAMPAIGN API
  // =========================
  Future<void> generateCampaign() async {
    if (productController.text.isEmpty ||
        audienceController.text.isEmpty ||
        platformController.text.isEmpty) {
      setState(() {
        campaignResult = "⚠️ Please fill all campaign fields";
      });
      return;
    }

    setState(() {
      loadingCampaign = true;
      campaignResult = "";
    });

    try {
      String res = await ApiService.generateCampaign(
        productController.text.trim(),
        audienceController.text.trim(),
        platformController.text.trim(),
      );

      setState(() {
        campaignResult = res;
      });
    } catch (e) {
      setState(() {
        campaignResult = "❌ Error: $e";
      });
    }

    setState(() {
      loadingCampaign = false;
    });
  }

  // =========================
  // DEMAND PREDICTION (AI BASED)
  // =========================
  Future<void> predictDemand() async {
    if (demandController.text.isEmpty) {
      setState(() {
        demandResult = "⚠️ Enter current data";
      });
      return;
    }

    setState(() {
      loadingDemand = true;
      demandResult = "";
    });

    try {
      String res = await ApiService.predictDemand(
        demandController.text.trim(),
      );

      setState(() {
        demandResult = res;
      });
    } catch (e) {
      setState(() {
        demandResult = "❌ Error: $e";
      });
    }

    setState(() {
      loadingDemand = false;
    });
  }

  // =========================
  // UI COMPONENTS
  // =========================

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget buildCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: hint),
    );
  }

  Widget resultBox(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text.isEmpty ? "Results will appear here..." : text,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Generator"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =========================
            // CAMPAIGN SECTION
            // =========================
            buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("📢 Marketing Campaign"),

                  buildInput(productController, "Product"),
                  const SizedBox(height: 10),

                  buildInput(audienceController, "Target Audience"),
                  const SizedBox(height: 10),

                  buildInput(platformController, "Platform"),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: loadingCampaign ? null : generateCampaign,
                    child: loadingCampaign
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Generate Campaign"),
                  ),

                  resultBox(campaignResult),
                ],
              ),
            ),

            // =========================
            // DEMAND PREDICTION SECTION
            // =========================
            buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("📈 Demand Prediction"),

                  const Text(
                    "Enter current data (sales, trends, season, etc.)",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),

                  buildInput(demandController, "Example: 200 sales, festive season, high ads"),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: loadingDemand ? null : predictDemand,
                    child: loadingDemand
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Predict Demand"),
                  ),

                  resultBox(demandResult),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}