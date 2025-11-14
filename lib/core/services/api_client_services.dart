/// Dummy API Client Service
/// This service simulates API calls with delays
class APIClientServices {
  // Simulate network delay
  static Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Dummy login API
  /// Returns success if email contains '@' and password length >= 6
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await _delay();

    // Dummy validation
    if (!email.contains('@') || password.length < 6) {
      throw Exception('Invalid email or password');
    }

    // Dummy success response
    return {
      'success': true,
      'token': 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': '1',
        'email': email,
        'name': email.split('@')[0],
      },
    };
  }

  /// Dummy signup API
  /// Returns success if email contains '@' and password length >= 6
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    await _delay();

    // Dummy validation
    if (!email.contains('@') || password.length < 6 || name.isEmpty) {
      throw Exception('Invalid input data');
    }

    // Dummy success response
    return {
      'success': true,
      'token': 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        'id': '1',
        'email': email,
        'name': name,
      },
    };
  }

  /// Dummy logout API
  static Future<void> logout() async {
    await _delay();
    // Dummy logout - just simulate delay
  }
}
