import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // Load từ .env file
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000/api/client';

  static String get apiHost =>
      dotenv.env['API_HOST'] ?? 'localhost';

  static int get apiPort =>
      int.tryParse(dotenv.env['API_PORT'] ?? '4000') ?? 4000;

  static String get apiPath =>
      dotenv.env['API_PATH'] ?? '/api/client';

  static String get fullBaseUrl => baseUrl;

  // Cloudinary Config (nếu cần upload ảnh)
  static String get cloudinaryName => dotenv.env['CLOUD_NAME'] ?? '';
  static String get cloudinaryApiKey => dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static String get cloudinaryApiSecret => dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

  // Timeout Configuration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Environment
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static bool get isDevelopment => !isProduction;

  // Logging
  static bool get enableLogging => isDevelopment;
}

// Environment Configuration
class EnvironmentConfig {
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';

  static String get currentEnvironment =>
      dotenv.env['ENVIRONMENT'] ?? development;

  static String getBaseUrl() {
    final env = dotenv.env['ENVIRONMENT'] ?? development;

    switch (env) {
      case development:
        return dotenv.env['API_BASE_URL'] ??
            'http://localhost:4000/api/client';
      case staging:
        return dotenv.env['STAGING_API_URL'] ??
            'https://staging-api.example.com/api/client';
      case production:
        return dotenv.env['PROD_API_URL'] ??
            'https://api.example.com/api/client';
      default:
        return dotenv.env['API_BASE_URL'] ??
            'http://localhost:4000/api/client';
    }
  }

  static void setEnvironment(String env) {
    // Không cần set vì đọc từ .env
    // Nếu muốn override, có thể thêm logic ở đây
  }
}