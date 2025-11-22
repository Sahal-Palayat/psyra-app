import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:psyra/constants/api_constants.dart';

/// API Client Service
/// Handles all HTTP requests to the backend API
class APIClientServices {
  /// Login API
  /// Makes a POST request to the login endpoint
  /// Response format: { "status": true, "message": "...", "data": { ... } }
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${APIConstants.baseUrl}${APIConstants.loginEndpoint}');
      
      // Debug: Print the URL being called
      print('🔵 ========================================');
      print('🔵 API CALL DETAILS');
      print('🔵 ========================================');
      print('🔵 Base URL: ${APIConstants.baseUrl}');
      print('🔵 Endpoint: ${APIConstants.loginEndpoint}');
      print('🔵 Full URL: $url');
      print('🔵 Login Request: email=$email');
      print('🔵 ========================================');
      
      final requestBody = jsonEncode({
        'email': email,
        'password': password,
      });
      
      final response = await http.post(
        url,
        headers: APIConstants.headers,
        body: requestBody,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      // Debug: Print response details
      print('🔵 Response Status Code: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');

      // Check if response body is empty
      if (response.body.isEmpty) {
        throw Exception('Empty response from server. Status code: ${response.statusCode}');
      }

      // Try to parse JSON
      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Invalid JSON response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if response has status field
        if (responseData['status'] == true && responseData['data'] != null) {
          return responseData['data'] as Map<String, dynamic>;
        } else if (responseData['data'] != null) {
          // Return data even if status is not explicitly true
          return responseData['data'] as Map<String, dynamic>;
        } else {
          // Fallback: return the whole response if no data wrapper
          return responseData;
        }
      } else {
        // Handle error response
        final errorMessage = responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            responseData['errors']?.toString() ??
            'Login failed with status code: ${response.statusCode}';
        
        // If 404, provide helpful message about endpoint
        if (response.statusCode == 404) {
          print('❌ ========================================');
          print('❌ ENDPOINT NOT FOUND (404)');
          print('❌ ========================================');
          print('❌ Current endpoint: ${APIConstants.loginEndpoint}');
          print('❌ Full URL tried: $url');
          print('❌ Please verify the correct endpoint path.');
          print('❌ Common patterns: /api/login, /api/auth/login, /auth/login');
          print('❌ ========================================');
        }
        
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      print('🔴 Client Exception: $e');
      throw Exception('Network error. Please check your internet connection. Error: ${e.message}');
    } on FormatException catch (e) {
      print('🔴 Format Exception: $e');
      throw Exception('Invalid response from server: ${e.message}');
    } catch (e) {
      print('🔴 Exception: $e');
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      throw Exception(errorMessage.isEmpty ? 'An unexpected error occurred' : errorMessage);
    }
  }

  /// Signup API
  /// Makes a POST request to the signup endpoint
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final url = Uri.parse('${APIConstants.baseUrl}${APIConstants.signupEndpoint}');
      
      final response = await http.post(
        url,
        headers: APIConstants.headers,
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(
          responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              'Signup failed',
        );
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response from server.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout API
  /// Makes a POST request to the logout endpoint
  static Future<void> logout({String? token}) async {
    try {
      final url = Uri.parse('${APIConstants.baseUrl}${APIConstants.logoutEndpoint}');
      
      final headers = token != null
          ? APIConstants.getHeadersWithAuth(token)
          : APIConstants.headers;

      final response = await http.post(
        url,
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(
          responseData['message']?.toString() ??
              responseData['error']?.toString() ??
              'Logout failed',
        );
      }
    } on http.ClientException {
      throw Exception('Network error. Please check your internet connection.');
    } on FormatException {
      throw Exception('Invalid response from server.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
