import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_constants.dart';
import 'api_exceptions.dart';
import 'api_logger.dart';
import 'api_response.dart';
import '../storage/local_storage.dart';
import '../utils/network_utils.dart';
import 'package:gobus_app/main.dart';

class ApiClient {
  /// Call this when a 401 is detected anywhere
  static Future<void> _handleUnauthorized() async {
    await LocalStorage.clear(); // wipe token

    // Navigate to login from anywhere in the app
    navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (_) => false);
  }

  static bool _isAuthError(String message) {
    final lower = message.toLowerCase();
    return lower.contains('unauthenticated') ||
        lower.contains('unauthorized') ||
        lower.contains('token') ||
        lower.contains('expired');
  }

  // ─── POST ──────────────────────────────────────────────────────────────────

  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? parser,
    Map<String, String>? headers,
  }) async {
    final hasInternet = await NetworkUtils.hasInternet();
    if (!hasInternet) return ApiResponse.failure("No internet connection");

    try {
      final token = await LocalStorage.getToken();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      ApiLogger.logRequest(uri.toString(), body);

      final response = await http
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: ApiConstants.contentType,
              HttpHeaders.acceptHeader: ApiConstants.accept,
              if (token != null)
                HttpHeaders.authorizationHeader: "Bearer $token",
              ...?headers,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: ApiConstants.connectTimeout));

      ApiLogger.logResponse(response.body);

      // ✅ Handle 401 globally
      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return ApiResponse.failure("Session expired. Please login again.");
      }

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true) {
        return ApiResponse.success(
          parser != null ? parser(decoded['data']) : decoded['data'],
        );
      } else {
        // Also catch auth errors by message (some backends return 200 with error)
        final errorMsg = decoded['error'] ?? decoded['message'] ?? '';
        if (_isAuthError(errorMsg)) {
          await _handleUnauthorized();
          return ApiResponse.failure("Session expired. Please login again.");
        }
        return ApiResponse.failure(
          errorMsg.isNotEmpty ? errorMsg : "Something went wrong",
        );
      }
    } catch (e) {
      ApiLogger.logError(e);
      return ApiResponse.failure(e.toString());
    }
  }

  // ─── GET ───────────────────────────────────────────────────────────────────

  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    T Function(dynamic json)? parser,
  }) async {
    final hasInternet = await NetworkUtils.hasInternet();
    if (!hasInternet) return ApiResponse.failure("No internet connection");

    try {
      final token = await LocalStorage.getToken();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      ApiLogger.logRequest(uri.toString(), null);

      final response = await http
          .get(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: ApiConstants.contentType,
              HttpHeaders.acceptHeader: ApiConstants.accept,
              if (token != null)
                HttpHeaders.authorizationHeader: "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: ApiConstants.connectTimeout));

      ApiLogger.logResponse(response.body);

      // ✅ Handle 401 globally
      if (response.statusCode == 401) {
        await _handleUnauthorized();
        return ApiResponse.failure("Session expired. Please login again.");
      }

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == true) {
        return ApiResponse.success(
          parser != null ? parser(decoded['data']) : decoded['data'],
        );
      } else {
        final errorMsg = decoded['error'] ?? decoded['message'] ?? '';
        if (_isAuthError(errorMsg)) {
          await _handleUnauthorized();
          return ApiResponse.failure("Session expired. Please login again.");
        }
        return ApiResponse.failure(
          errorMsg.isNotEmpty ? errorMsg : "Something went wrong",
        );
      }
    } catch (e) {
      ApiLogger.logError(e);
      return ApiResponse.failure(e.toString());
    }
  }
  // ─── PUT ───────────────────────────────────────────────────────────────────

  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? parser,
  }) async {
    return _send<T>('PUT', endpoint, body: body, parser: parser);
  }

  // ─── DELETE ────────────────────────────────────────────────────────────────

  static Future<ApiResponse<void>> delete(String endpoint) async {
    return _send<void>('DELETE', endpoint);
  }

  // ─── Internal ──────────────────────────────────────────────────────────────

  static Future<ApiResponse<T>> _send<T>(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    T Function(dynamic json)? parser,
    Map<String, String>? extraHeaders,
  }) async {
    final hasInternet = await NetworkUtils.hasInternet();
    if (!hasInternet) return ApiResponse.failure('No internet connection');

    try {
      final token = await LocalStorage.getToken();
      final uri = Uri.parse(ApiConstants.baseUrl + endpoint);
      final headers = {..._buildHeaders(token), ...?extraHeaders};

      ApiLogger.logRequest(uri.toString(), body);

      http.Response response;

      switch (method) {
        case 'PUT':
          response = await http
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: ApiConstants.connectTimeout));
          break;
        case 'DELETE':
          response = await http
              .delete(uri, headers: headers)
              .timeout(const Duration(seconds: ApiConstants.connectTimeout));
          break;
        default: // POST
          response = await http
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(const Duration(seconds: ApiConstants.connectTimeout));
      }

      ApiLogger.logResponse(response.body);
      return _parseResponse(response, parser);
    } catch (e) {
      ApiLogger.logError(e);
      return ApiResponse.failure(e.toString());
    }
  }

  static Map<String, String> _buildHeaders(String? token) {
    return {
      HttpHeaders.contentTypeHeader: ApiConstants.contentType,
      HttpHeaders.acceptHeader: ApiConstants.accept,
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  static ApiResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic json)? parser,
  ) {
    final decoded = jsonDecode(response.body);
    if (decoded['status'] == true) {
      return ApiResponse.success(
        parser != null ? parser(decoded['data']) : decoded['data'],
      );
    }
    return ApiResponse.failure(
      decoded['error'] ?? decoded['message'] ?? 'Something went wrong',
    );
  }
}
