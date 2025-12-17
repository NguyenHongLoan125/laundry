import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laundry_app/src/app.dart';
import 'package:laundry_app/src/core/di/auth_dependency_injection.dart';

Future<void> main() async {
  // Đảm bảo Flutter đã khởi tạo
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Auth dependencies
  AuthDI.init();

  // Chạy app
  runApp(const LaundryApp());
}