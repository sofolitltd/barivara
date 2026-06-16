import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:55323';
  static String get invoiceLinkBase => '$baseUrl/invoice';
}
