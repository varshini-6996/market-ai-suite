import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {
  final budgetAController = TextEditingController();
  final budgetBController = TextEditingController();

  double probA = 0.5;
  double probB = 0.5;

  double urgencyA = 1.0;
  double urgencyB = 1.0;

  Map<String, dynamic>? result;
  bool isLoading = false;

  Future<void> compare() async {
    final budgetA = double.tryParse(budgetAController.text);
    final budgetB = double.tryParse(budgetBController.text);

    if (budgetA == null || budgetB == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid budgets")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await ApiService.compareLeads(
        budgetA: budgetA,
        probA: probA,
        urgencyA: urgencyA,
        budgetB: budgetB,
        probB: probB,
        urgencyB: urgencyB,
      );

      setState(() => result = response);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comparison failed")),
      );
    }

    setState(() => isLoading = false);
  }

  Widget buildSectionCard(String title, TextEditingController controller,
      double prob, Function(double) onProbChanged, double urgency,
      Function(double?) onUrgencyChanged) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFDF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Budget",
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colors.deepPurple, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text("Probability", style: TextStyle(color: Colors.grey[700])),
          Slider(
            value: prob,
            min: 0,
            max: 1,
            divisions: 10,
            label: prob.toStringAsFixed(1),
            onChanged: onProbChanged,
            activeColor: Colors.deepPurple,
            inactiveColor: Colors.deepPurple[100],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<double>(
            value: urgency,
            decoration: const InputDecoration(
              labelText: "Urgency",
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
            items: const [
              DropdownMenuItem(value: 1.0, child: Text("Low")),
              DropdownMenuItem(value: 1.2, child: Text("Medium")),
              DropdownMenuItem(value: 1.5, child: Text("High")),
            ],
            onChanged: onUrgencyChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final valueA =
        result?["clientA"]?["expected_value"]?.toDouble() ?? 0.0;
    final valueB =
        result?["clientB"]?["expected_value"]?.toDouble() ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Lead Comparison"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionCard(
              "Client A",
              budgetAController,
              probA,
              (v) => setState(() => probA = v),
              urgencyA,
              (v) => setState(() => urgencyA = v!),
            ),
            buildSectionCard(
              "Client B",
              budgetBController,
              probB,
              (v) => setState(() => probB = v),
              urgencyB,
              (v) => setState(() => urgencyB = v!),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : compare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        "Compare",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: 30),
              Container(
                height: 250,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                              toY: valueA,
                              color: Colors.deepPurple,
                              width: 22)
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                              toY: valueB, color: Colors.deepPurple[300], width: 22)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                result!["recommendation"],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
