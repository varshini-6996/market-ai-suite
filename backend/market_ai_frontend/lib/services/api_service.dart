import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ Change this if using emulator
  static const String baseUrl = "http://localhost:8000";

  // =====================
  // COMMON PARSER
  // =====================
  static String parseResponse(http.Response response) {
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    try {
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data["status"] == "success") {
          return data["data"] ?? "No data returned";
        } else {
          return "❌ ${data["detail"] ?? "Unknown error"}";
        }
      } else {
        return "❌ Server Error: ${response.statusCode}";
      }
    } catch (e) {
      return "❌ JSON Error: $e\nRaw: ${response.body}";
    }
  }

  // =====================
  // CAMPAIGN
  // =====================
  static Future<String> generateCampaign(
      String product, String audience, String platform) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/campaign"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product": product,
          "audience": audience,
          "platform": platform,
        }),
      );

      return parseResponse(response);
    } catch (e) {
      return "❌ Connection Error: $e";
    }
  }

  // =====================
  // LEAD SCORE
  // =====================
  static Future<String> generateLeadScore(
      int budget, String urgency, String size, String req) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/lead-score"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "budget": budget,
          "urgency": urgency,
          "company_size": size,
          "requirement": req,
        }),
      );

      return parseResponse(response);
    } catch (e) {
      return "❌ Connection Error: $e";
    }
  }

  // =====================
  // DEMAND PREDICTION
  // =====================
  static Future<String> predictDemand(String rawData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/predict-demand"), // ✅ FIXED
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": rawData,
        }),
      );

      return parseResponse(response);
    } catch (e) {
      return "❌ Connection Error: $e";
    }
  }
}