import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final TextEditingController productController = TextEditingController();
  final TextEditingController audienceController = TextEditingController();
  final TextEditingController platformController = TextEditingController();
  final TextEditingController demandController = TextEditingController();

  String campaignResult = "";
  String demandResult = "";

  bool loadingCampaign = false;
  bool loadingDemand = false;

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

  Future<void> downloadPdf() async {
    try {
      await ApiService.downloadCampaignPdf(
        productController.text.trim(),
        audienceController.text.trim(),
        platformController.text.trim(),
        demandController.text.trim(),
      );
    } catch (e) {
      setState(() {
        campaignResult = "❌ PDF Download Failed: $e";
      });
    }
  }

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
      String res =
          await ApiService.predictDemand(demandController.text.trim());

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

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget buildCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFDF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }

  Widget resultBox(String text) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: SingleChildScrollView(
        child: SelectableText(
          text.isEmpty ? "Results will appear here..." : text,
          style: const TextStyle(fontSize: 15, height: 1.4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Generator"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("📢 Marketing Campaign"),
                  buildInput(productController, "Product"),
                  const SizedBox(height: 12),
                  buildInput(audienceController, "Target Audience"),
                  const SizedBox(height: 12),
                  buildInput(platformController, "Platform"),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loadingCampaign ? null : generateCampaign,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loadingCampaign
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Generate Campaign",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  resultBox(campaignResult),
                  if (campaignResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.download),
                        label: const Text("Download PDF"),
                        onPressed: downloadPdf,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitle("📈 Demand Prediction"),
                  const Text(
                    "Enter current data (sales, trends, season, etc.)",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  buildInput(demandController,
                      "Example: 200 sales, festive season, high ads"),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loadingDemand ? null : predictDemand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: loadingDemand
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Predict Demand",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
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
