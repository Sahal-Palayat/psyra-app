import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  static const bool useProd = true;

  // Base URLs
  // If your API base URL already includes /api, use: 'https://kochimetrocalc.me/api'
  // If not, use: 'https://kochimetrocalc.me' and endpoints will be /login, /signup, etc.
  static String get baseUrl {
    final url = useProd
        ? dotenv.env['https://kochimetrocalc.me'] ?? 'https://kochimetrocalc.me'
        : dotenv.env['NEXT_PUBLIC_API_URL_NGROK'] ??
            'https://a51018934dff.ngrok-free.app';
    print('🔵 Base URL: $url');
    return url;
  }

  // API Endpoints
  // Based on API spec: POST /client/login
  static const String loginEndpoint = '/client/login';
  static const String signupEndpoint = '/signup';
  static const String logoutEndpoint = '/logout';

  // Headers
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  static Map<String, String> getHeadersWithAuth(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}

/// Usage of [APIConstants]
/// final baseUrl = APIConstants.baseUrl;
/// final headers = APIConstants.headers;