import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ Flutter Web → localhost
  static const String baseUrl = "http://localhost:8000";

  // =============================
  // UNIVERSAL POST REQUEST
  // =============================
  static Future<String> _postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$baseUrl$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["data"]?.toString() ??
            data["message"]?.toString() ??
            "✅ Success";
      } else {
        return "❌ Server Error ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      return "❌ Connection Error: $e";
    }
  }

  // =============================
  // CAMPAIGN GENERATION
  // =============================
  static Future<String> generateCampaign(
      String product, String audience, String platform) {
    return _postRequest("/campaign", {
      "product": product,
      "audience": audience,
      "platform": platform,
    });
  }

  // =============================
  // DOWNLOAD CAMPAIGN PDF (WEB)
  // =============================
  static Future<void> downloadCampaignPdf(
  String product,
  String audience,
  String platform,
  String demandData,
) async {
  final url = Uri.parse("$baseUrl/campaign/pdf");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "product": product,
      "audience": audience,
      "platform": platform,
      "demand_data": demandData,
    }),
  );

  if (response.statusCode == 200) {
    final blob = html.Blob([response.bodyBytes]);
    final pdfUrl = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: pdfUrl)
      ..setAttribute("download", "campaign_report.pdf")
      ..click();

    html.Url.revokeObjectUrl(pdfUrl);
  } else {
    throw Exception("Failed to download PDF");
  }
}
static Future<String> generatePitch(
  String product,
  String audience,
  String problem,
) async {
  final url = Uri.parse("$baseUrl/pitch");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "product": product,
      "audience": audience,
      "problem": problem,
    }),
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return data["result"]?.toString() ??
        data["data"]?.toString() ??
        "No pitch generated";
  } else {
    throw Exception("Server Error ${response.statusCode}: ${response.body}");
  }
}
  // =============================
  // LEAD SCORE
  // =============================
  static Future<Map<String, dynamic>> compareLeads({
  required double budgetA,
  required double probA,
  required double urgencyA,
  required double budgetB,
  required double probB,
  required double urgencyB,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/compare-leads"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "clientA_budget": budgetA,
      "clientA_probability": probA,
      "clientA_urgency": urgencyA,
      "clientB_budget": budgetB,
      "clientB_probability": probB,
      "clientB_urgency": urgencyB,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Comparison failed");
  }
}

  // =============================
  // DEMAND PREDICTION
  // =============================
  static Future<String> predictDemand(String rawData) {
    return _postRequest("/predict-demand", {
      "data": rawData,
    });
  }
}
