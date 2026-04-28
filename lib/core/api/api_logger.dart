import 'dart:developer';

class ApiLogger {
  static void logRequest(String url, dynamic body) {
    log("➡️ API REQUEST: $url");
    log("📦 BODY: $body");
  }

  static void logResponse(dynamic response) {
    log("✅ API RESPONSE: $response");
  }

  static void logError(dynamic error) {
    log("❌ API ERROR: $error");
  }
}
