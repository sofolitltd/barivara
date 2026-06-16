import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SmsService {
  static String get _baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:55323';

  static Future<String?> sendReminder(String renterId, String invoiceId) async {
    final url = Uri.parse('$_baseUrl/api/send-reminder');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'renterId': renterId,
          'invoiceId': invoiceId,
        }),
      );
      if (resp.statusCode == 200) {
        return null;
      }
      final data = jsonDecode(resp.body);
      return data['error'] as String? ?? 'Failed to send SMS';
    } catch (e) {
      return 'Network error: $e';
    }
  }

  static Future<String?> sendReceipt(String renterId, String invoiceId) async {
    final url = Uri.parse('$_baseUrl/api/send-receipt');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'renterId': renterId,
          'invoiceId': invoiceId,
        }),
      );
      if (resp.statusCode == 200) {
        return null;
      }
      final data = jsonDecode(resp.body);
      return data['error'] as String? ?? 'Failed to send receipt';
    } catch (e) {
      return 'Network error: $e';
    }
  }
}
