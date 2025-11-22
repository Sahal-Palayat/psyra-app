import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
    print('✅ Environment variables loaded successfully');
    print('🔵 API URL: ${dotenv.env['https://kochimetrocalc.me']}');
  } catch (e) {
    print('⚠️ Warning: Could not load .env file: $e');
    print('⚠️ Using default API URL');
  }
  
  runApp(const App());
}

